// Stylized Water 3 © Staggart Creations (http://staggart.xyz)
// COPYRIGHT PROTECTED UNDER THE UNITY ASSET STORE EULA (https://unity.com/legal/as-terms)
//
// ⚠️ WARNING: UNAUTHORIZED USE OR DISTRIBUTION IS STRICTLY PROHIBITED
// • Copying, referencing, or reverse-engineering this source code for the creation of new Asset Store or derivative products,
//   or any other publicly distributed content is strictly forbidden and will result in legal action.
// • Studying this file for the purpose of reproducing its functionality in your own assets or tools is not permitted.
// • If you are viewing this file as a reference, please close it immediately to avoid unintentional design influence or potential EULA violations.
// • Uploading this file or any derivative of it to a public GitHub or similar repository will trigger an automated DMCA takedown request.
// • Studying to understand for personal, educational or integration purposes is allowed, studying to reproduce is not.

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using Object = UnityEngine.Object;
using Random = UnityEngine.Random;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace StylizedWater3.RiverModeler
{
    [ExecuteAlways]
    public class RiverAudioManager : MonoBehaviour
    {
        public static RiverAudioManager Instance { get; internal set; }
        
        [NonSerialized]
        private static AudioListener audioListener;
        public bool AudioListenerPresent => audioListener?.enabled ?? false;
        
        [NonSerialized]
        private UnityEngine.Pool.ObjectPool<AudioSource> audioSourcePool;
        
        private static readonly List<RiverSegment> segments = new();
        public static IReadOnlyList<RiverSegment> Segments => segments;
        
        public int ActiveInPool => audioSourcePool?.CountActive ?? 0;
        public int InactiveInPool => audioSourcePool?.CountAll ?? 0;

        public static void Register(RiverSegment segment)
        {
            if (segment == null || segments.Contains(segment))
                return;

            segments.Add(segment);
        }

        public static void Unregister(RiverSegment segment)
        {
            if (segment == null)
                return;

            segments.Remove(segment);
        }
        
        private void FixedUpdate()
        {
            UpdateAudio();
        }

        public void UpdateAudio()
        {
            if (!audioListener)
            {
#if UNITY_6000_4_OR_NEWER
                audioListener = FindAnyObjectByType<AudioListener>(FindObjectsInactive.Exclude);
#else
                audioListener = FindFirstObjectByType<AudioListener>();
#endif
            }

            if (!audioListener || audioListener.enabled == false) return;
            
            EnsureAudioSourcePool();
            
            Vector3 listenerPosition = audioListener.transform.position;
            
            foreach (RiverSegment segment in segments)
            {
                ProcessSegmentAudio(listenerPosition, segment);
            }
        }
        
        private void ProcessSegmentAudio(Vector3 listenerPosition, RiverSegment segment)
        {
            //Broad phase, radius check. 
            float sqrDistance = (listenerPosition - segment.AudioBounds.center).sqrMagnitude;
            bool isWithinRadius = sqrDistance <= segment.AudioRadius * segment.AudioRadius;
                    
            if (!isWithinRadius)
            {
                if (segment.isWithinEarshot)
                {
                    OnSegmentExitingEarshot(segment);
                }

                return;
            }

            //Narrow phase, bounds check
            bool isInBounds = segment.AudioBoundsContains(listenerPosition);

            if (isInBounds)
            {
                if (!segment.isWithinEarshot)
                {
                    OnSegmentEnteringEarshot(segment);
                }
            }
            else
            {
                if (segment.isWithinEarshot)
                {
                    OnSegmentExitingEarshot(segment);
                }
            }
        }

        //Acquire audio sources from pool and position them
        void OnSegmentEnteringEarshot(RiverSegment segment)
        {
            segment.isWithinEarshot = true;
            //Debug.Log($"{segment.gameObject.name} entered earshot");
            
            int emitterCount = segment.AudioEmitters.Length;

            if (segment.audioProfile == null)
            {
                throw new Exception("[RiverAudioManager] The Audio Profile is missing on a river segment. This is assigned during river generation normally, check that it isn't missing from the project.");
            }
            segment.ResizeAudioSourceArray(emitterCount);

            for (int i = 0; i < emitterCount; i++)
            {
                AudioSource audioSource = audioSourcePool.Get(); //Get from pool
                audioSource.enabled = true;
                
                segment.SetAudioSource(i, audioSource);
                segment.SetEmitterProperties(segment.AudioEmitters[i], audioSource);

                if (audioSource.clip == null)
                {
                    throw new Exception(
                        $"[RiverAudioManager] The Audio Profile is missing a clip for the {segment.AudioEmitters[i].type} type. Check the profile and ensure all audio clips are assigned.");
                }
                else
                {
                    //Offset the starting point
                    audioSource.time = Random.Range(0f, audioSource.clip.length);
                    audioSource.Play();
                }
            }
        }

        //Return audio sources to pool
        void OnSegmentExitingEarshot(RiverSegment segment)
        {
            segment.isWithinEarshot = false;
            //Debug.Log($"{segment.gameObject.name} exited earshot");
            
            int emitterCount = segment.AudioEmitters.Length;
            
            for (int i = 0; i < emitterCount; i++)
            {
                //Return audio sources to pool
                AudioSource audioSource = segment.GetAudioSource(i);

                if (!audioSource) continue;

                segment.SetAudioSource(i, null);
                audioSourcePool.Release(audioSource);
            }
            
        }

        private void OnDrawGizmosSelected()
        {
            if (!Application.isPlaying) return;
            
            foreach (RiverSegment segment in segments)
            {
                if(segment.gameObject.activeSelf == false) continue;
                
                if (segment.isWithinEarshot)
                {
                    Gizmos.color = Color.yellow;
                    Gizmos.DrawWireCube(segment.AudioBounds.center, segment.AudioBounds.size);
                    Gizmos.DrawWireSphere(segment.AudioBounds.center, segment.AudioRadius);
                    
                    Structs.AudioEmitter[] audioEmitters = segment.AudioEmitters;
                    
                    if (audioEmitters != null)
                    {
                        for (int i = 0; i < audioEmitters.Length; i++)
                        {
                            //No need to draw the audio source radius, they'll already have gizmos

#if UNITY_EDITOR
                            GUI.color = Color.black;
                            Handles.Label((Vector3)audioEmitters[i].position + (Vector3.up * 3f), $"{audioEmitters[i].type}", EditorStyles.largeLabel);
#endif
                        }
                    }
                    
                    Gizmos.color = new Color(1, 1, 0f, 0.75f);
                    Gizmos.DrawMesh(segment.mesh, segment.gameObject.transform.position, segment.gameObject.transform.rotation);
                }
            }
        }

        #region Object Pooling
        private int GetAudioPoolSize()
        {
            //Assume one audio source per 8 units on a 100m segment. Multiply by 2 (assumed number of segments in range at a time)
            return 24;
        }
        
        private void EnsureAudioSourcePool()
        {
            if (audioSourcePool != null) return;
            
            int poolSize = GetAudioPoolSize();
            
            //Debug.Log($"Created audio source pool with {poolSize} audio sources");
            
            audioSourcePool = new UnityEngine.Pool.ObjectPool<AudioSource>(
                CreatePooledAudioSource,
                OnTakeAudioSourceFromPool,
                OnReturnAudioSourceToPool,
                OnDestroyPooledAudioSource,
                true,
                poolSize,
                poolSize
            );
        }

        private AudioSource CreatePooledAudioSource()
        {
            GameObject audioSourceObject = new GameObject("Pooled River Audio Source");
            audioSourceObject.transform.SetParent(this.transform);
            audioSourceObject.hideFlags = HideFlags.DontSave;

            AudioSource audioSource = audioSourceObject.AddComponent<AudioSource>();
            audioSource.enabled = false;
            audioSource.playOnAwake = false;
            audioSource.dopplerLevel = 0f;
            
            return audioSource;
        }

        private void OnTakeAudioSourceFromPool(AudioSource audioSource)
        {
            audioSource.gameObject.SetActive(true);
            audioSource.enabled = true;
        }

        private void OnReturnAudioSourceToPool(AudioSource audioSource)
        {
            audioSource.Stop();
            audioSource.clip = null;
            audioSource.enabled = false;
            audioSource.gameObject.SetActive(false);
        }

        private void OnDestroyPooledAudioSource(AudioSource audioSource)
        {
            if (audioSource)
            {
                CoreUtils.Destroy(audioSource.gameObject);
            }
        }

        [ContextMenu("Clear Audio Source Pool")]
        public void ClearAudioSourcePool()
        {
            foreach (RiverSegment segment in segments)
            {
                if (segment == null || segment.AudioEmitters == null)
                    continue;

                int emitterCount = segment.AudioEmitters.Length;

                for (int i = 0; i < emitterCount; i++)
                {
                    AudioSource audioSource = segment.GetAudioSource(i);

                    if (!audioSource)
                        continue;

                    segment.SetAudioSource(i, null);
                    audioSourcePool.Release(audioSource);
                }
                
                segment.isWithinEarshot = false;
            }

            audioSourcePool.Clear();
            audioSourcePool.Dispose();
            audioSourcePool = null;
        }
        #endregion
        
        #region Singleton
        private void OnEnable()
        {
            RegisterInstance();
        }
        
        private void Awake()
        {
            RegisterInstance();

            if (Instance == this && Application.isPlaying)
            {
                DontDestroyOnLoad(gameObject);
            }
        }
        
        private void OnDisable()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }
        
        private void RegisterInstance()
        {
            if (Instance != null && Instance != this)
            {
                if (Application.isPlaying)
                {
                    Destroy(gameObject);
                }

                return;
            }

            Instance = this;
        }
        #endregion
    }
}