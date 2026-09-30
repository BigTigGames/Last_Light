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
using Unity.Collections;
using Unity.Collections.LowLevel.Unsafe;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Rendering;
#if SPLINES
using UnityEngine.Splines;
#endif
using Random = UnityEngine.Random;
#if VFX_GRAPH
using UnityEngine.VFX;
#endif

namespace StylizedWater3.RiverModeler
{
    [ExecuteAlways]
    public class RiverSegment : MonoBehaviour
    {
        [SerializeField]
        private SplineRiver _river;

        public SplineRiver River
        {
            get => _river;
            internal set => _river = value;
        }

        [SerializeField] private Vector2 _curveRange;
        /// <summary>
        /// The start/end position of the segment in the spline
        /// </summary>
        public Vector2 CurveRange { get => _curveRange; internal set => _curveRange = value; }

        public Mesh mesh;
        [SerializeField] private Bounds meshBounds;
        
        [SerializeField]
        private MeshFilter meshFilter;
        [SerializeField]
        private MeshRenderer meshRenderer;

        #pragma warning disable CS0108
        [SerializeField]
        private MeshCollider collider;
        #pragma warning restore CS0108

        [SerializeField]
        private BoxCollider boxTrigger;
        
        [SerializeField]
        private float audioRadius;
        /// <summary>
        /// The maximum audible range of the segment
        /// </summary>
        public float AudioRadius { get => audioRadius; internal set => audioRadius = value; }
        [SerializeField]
        private Bounds audioBounds;
        /// <summary>
        /// Bounds encapsulating all the audio emitters
        /// </summary>
        public Bounds AudioBounds { get => audioBounds; internal set => audioBounds = value; }
        
        public RiverAudioProfile audioProfile;
        
        [SerializeField]
        private Structs.AudioEmitter[] audioEmitters = Array.Empty<Structs.AudioEmitter>();
        public Structs.AudioEmitter[] AudioEmitters => audioEmitters;

        //Audio sources acquired from the pool
        [NonSerialized]
        private AudioSource[] audioSources = Array.Empty<AudioSource>();
            
        //State
        internal bool isWithinEarshot = false;
        
#if VFX_GRAPH
        public VisualEffect foamVFX;

        [SerializeField]
        private Structs.ParticleEmitter[] particles = Array.Empty<Structs.ParticleEmitter>();
        public int ParticleCount => particles.Length;
        private GraphicsBuffer particleBuffer;
#endif

        private void OnEnable()
        {
            if(Application.isPlaying) RiverAudioManager.Register(this);
            
            #if VFX_GRAPH
            //GraphicsBuffers aren't serialized, so particles need to be reloaded from a serialized array
            LoadVFXData();
            #endif
        }

        private void OnDisable()
        {
            if(Application.isPlaying) RiverAudioManager.Unregister(this);
            
#if VFX_GRAPH
            DisposeVFXBuffer();
#endif
        }
        
        private void OnDestroy()
        {
#if VFX_GRAPH
            DisposeVFXBuffer();
#endif
        }
        
        public static RiverSegment Create(Transform parent)
        {
            GameObject gameObject = new GameObject("River Segment");
            gameObject.transform.SetParent(parent);
            gameObject.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
            
            RiverSegment segment = gameObject.AddComponent<RiverSegment>();
            segment.meshFilter = gameObject.AddComponent<MeshFilter>();
            segment.meshRenderer = gameObject.AddComponent<MeshRenderer>();
            segment.meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
            //collider = gameObject.AddComponent<MeshCollider>();
            
            segment.mesh = new Mesh();
            segment.meshFilter.sharedMesh = segment.mesh;
            
            gameObject.layer = LayerMask.NameToLayer("Water");
            WaterObject waterObject = gameObject.AddComponent<WaterObject>();
            
            return segment;
        }

        public void UpdateTrigger(bool state)
        {
            if(!state && boxTrigger) CoreUtils.Destroy(boxTrigger);
            if(state && !boxTrigger) boxTrigger = gameObject.AddComponent<BoxCollider>();

            if (boxTrigger)
            {
                boxTrigger.center = this.transform.InverseTransformPoint(meshBounds.center);
                boxTrigger.size = this.transform.InverseTransformVector(meshBounds.size);
                boxTrigger.isTrigger = true;
            }
        }

        public void UpdateCollider(bool state)
        {
            if(!state && collider) CoreUtils.Destroy(collider);
            if(state && !collider) collider = gameObject.AddComponent<MeshCollider>();
            
            if (collider)
            {
                collider.sharedMesh = mesh;
                //collider.convex = true;
            }
        }

        #region Spline
        #if SPLINES
        /// <summary>
        /// Find the nearest spline point to the given world position. This method uses direct spline sampling so much be used sparingly.
        /// </summary>
        /// <param name="worldPosition"></param>
        /// <param name="radius"></param>
        /// <param name="point"></param>
        /// <param name="tangent"></param>
        /// <param name="up"></param>
        /// <param name="sampleDistance">Set this as high as possible for best performance</param>
        /// <exception cref="Exception"></exception>
        public bool FindNearestSplinePoint(Vector3 worldPosition, out float3 point, out float3 tangent, out float3 up, out float t, float sampleDistance = 1f)
        {
            if (!River || !River.Owner)
            {
                throw new Exception(
                    "RiverSegment is missing a River or River.owner, cannot get spline point. It has likely been orphaned.");
            }

            if (!River.Owner.SplineContainer)
            {
                throw new Exception("RiverSegment is missing a SplineContainer, cannot get spline point. It has likely been orphaned.");
            }
            
            SplineContainer splineContainer = River.Owner.SplineContainer;
            Vector3 localPosition = splineContainer.transform.InverseTransformPoint(worldPosition);
            Spline spline = splineContainer[River.SplineIndex];
            
            float curveLength = CurveRange.y - CurveRange.x;
            
            float splineLength = spline.GetLength();
            
            float minDistance = float.MaxValue;

            float minT = CurveRange.x / splineLength;
            float maxT = CurveRange.y / splineLength;
            
            int sampleCount = Mathf.CeilToInt(curveLength / Mathf.Max(0.02f, sampleDistance));
            sampleCount = Mathf.Max(2, sampleCount);
            
            float nearestT = -1;
            
            //Sample the spline between minT and maxT
            //Store the nearest point and return it
            for (int i = 0; i < sampleCount; i++)
            {
                float sampleT = (i / (float)sampleCount);
                float normalizedT = Mathf.Lerp(minT, maxT, sampleT);

                Vector3 samplePoint = spline.EvaluatePosition(normalizedT);

                float distance = Vector3.Distance(localPosition, samplePoint);

                if (distance < minDistance)
                {
                    minDistance = distance;
                    nearestT = normalizedT;
                }
            }

            if (nearestT >= 0)
            {
                t = nearestT;
                spline.Evaluate(t, out point,out tangent, out up);
                
                //Convert to world-space
                point = splineContainer.transform.TransformPoint(point);
                tangent = splineContainer.transform.TransformDirection(tangent);
                up = splineContainer.transform.TransformDirection(up);

                return true;
            }

            //Failed
            t = -1;
            point = default;
            tangent = default;
            up = default;
            return false;
        }

        public bool FindNearestPointOnRiver(float3 worldPosition, out float3 point, out float3 direction, out float3 up, out float t, float sampleDistance = 1f)
        {
            if (FindNearestSplinePoint(worldPosition, out var splinePoint, out var splineTangent, out var splineUp, out t, sampleDistance))
            {
                float width = River.Owner.SampleWidth(River.SplineIndex, t) * 0.5f;

                float3 splineForward = math.normalize(splineTangent);
                float3 right = math.normalize(math.cross(splineForward, splineUp));
                
                float3 offsetFromCenter = worldPosition - splinePoint;
                float distanceFromCenter = math.dot(offsetFromCenter, right);
                float clampedDistanceFromCenter = math.clamp(distanceFromCenter, -width, width);
                
                point = splinePoint + right * clampedDistanceFromCenter;
                direction = splineForward;
                up = splineUp;

                return true;
            }
            
            //Failed
            t = -1;
            point = default;
            direction = default;
            up = default;

            return false;
        }
        #endif
        #endregion

        #region Audio
        public void SetAudioEmitters(RiverAudioProfile profile, NativeList<Structs.AudioEmitter> newEmitters)
        {
            this.audioProfile = profile;
            int emitterCount = newEmitters.Length;

            Array.Resize(ref audioEmitters, emitterCount);
            
            unsafe
            {
                Structs.AudioEmitter* emittersPtr = newEmitters.GetUnsafeReadOnlyPtr();
                for (int i = 0; i < emitterCount; i++)
                {
                    audioEmitters[i] = emittersPtr[i];
                }
            }
        }

        public void ClearAudioEmitters()
        {
            audioEmitters = Array.Empty<Structs.AudioEmitter>();
            audioProfile = null;
        }
        
        public AudioSource GetAudioSource(int index)
        {
            return index >= 0 && index < audioSources.Length ? audioSources[index] : null;
        }

        public void ResizeAudioSourceArray(int count)
        {
            Array.Resize(ref audioSources, count);
        }
        
        public void SetAudioSource(int index, AudioSource audioSource)
        {
            //ResizeAudioSourceArray(index + 1);
            audioSources[index] = audioSource;
        }

        public void SetEmitterProperties(Structs.AudioEmitter emitter, AudioSource audioSource)
        {
            float pitchVariance = 0f;
            switch (emitter.type)
            {
                case Structs.AudioEmitter.Type.Stream:
                {
                    audioSource.clip = audioProfile.stream.clip;
                    audioSource.volume = audioProfile.stream.volume;
                    pitchVariance = audioProfile.stream.pitchVariation;
                }
                    break;
                case Structs.AudioEmitter.Type.Rapids:
                {
                    audioSource.clip = audioProfile.rapids.clip;
                    audioSource.volume = audioProfile.rapids.volume;
                    pitchVariance = audioProfile.rapids.pitchVariation;
                    
                }
                    break;
                case Structs.AudioEmitter.Type.Cascade:
                {
                    audioSource.clip = audioProfile.cascade.clip;
                    audioSource.volume = audioProfile.cascade.volume;
                    pitchVariance = audioProfile.cascade.pitchVariation;
                }
                    break;
            }

            pitchVariance *= 0.01f; //Convert percent to a range of 0-1

            audioSource.outputAudioMixerGroup = audioProfile.mixerGroup;
            audioSource.transform.position = emitter.position;
            audioSource.minDistance = emitter.minRadius;
            audioSource.maxDistance = emitter.maxRadius;
            audioSource.spatialBlend = 1f;
            
            audioSource.pitch = Random.Range(1f-pitchVariance, 1f+pitchVariance);
            audioSource.rolloffMode = AudioRolloffMode.Linear;
            audioSource.loop = true;

            //Need to start each one separately to avoid phasing issues
            audioSource.playOnAwake = false;
        }

        public bool AudioBoundsContains(Vector3 point)
        {
            return audioBounds.Contains(point);
        }
        #endregion
        
        public void UpdateBounds()
        {
            meshBounds.center = meshRenderer.bounds.center;
            meshBounds.size = meshRenderer.bounds.size;

            audioBounds = meshBounds;

            for (int i = 0; i < audioEmitters.Length; i++)
            {
                Vector3 center = audioEmitters[i].position;
                Vector3 extents = Vector3.one * audioEmitters[i].maxRadius;
                
                audioBounds.Encapsulate(center - extents);
                audioBounds.Encapsulate(center + extents);
            }
            Vector3 size = audioBounds.size;
            
            //Actually twice the size, since it needs to encompass the bounding box
            audioRadius =  Mathf.Max(size.x, Mathf.Max(size.y, size.z));
        }

        public bool MeshBoundsContains(Vector3 point)
        {
            return meshBounds.Contains(point);
        }
        
        public void SetMaterial(Material newMaterial)
        {
            meshRenderer.sharedMaterial = newMaterial;
        }
        
        public void SetSortingOrder(int order)
        {
            meshRenderer.sortingOrder = order;
        }

        public void SetLODBias(float bias)
        {
            #if UNITY_6000_2_OR_NEWER
            meshRenderer.meshLodSelectionBias = bias;
            #endif
        }
        
        #if VFX_GRAPH
        public void CreateVFXData(NativeList<Structs.ParticleEmitter> particlesList)
        {
            SerializeVFXData(particlesList);
            LoadVFXData();
        }

        public void SerializeVFXData(NativeList<Structs.ParticleEmitter> particlesArray)
        {
            int particleCount = particlesArray.Length;

            if (particleCount == 0)
            {
                ClearParticles();
                return;
            }
            
            Array.Resize(ref particles, particleCount);

            unsafe
            {
                Structs.ParticleEmitter* particlesPtr = particlesArray.GetUnsafeReadOnlyPtr();
                for (int i = 0; i < particleCount; i++)
                {
                    particles[i] = particlesPtr[i];
                }
            }
        }
        
        private void LoadVFXData()
        {
            if (!foamVFX) return;

            if (foamVFX.HasGraphicsBuffer("ParticleEmitters") == false)
            {
                Debug.LogError($"[River Modeler] Failed to create VFX data. The VFX Graph appears to be broken. If it was imported without the Visual Effects package installed this will have happened." +
                               $" To remedy this, please re-import the \"VFX\" folder from the asset store.");
                return;
            }
            int particleCount = particles.Length;
            
            if (particleCount > 0)
            {
                int structStride = Structs.ParticleEmitter.GetStride();
                
                DisposeVFXBuffer();
                particleBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, particleCount, structStride);
                
                particleBuffer.SetData(particles);
                
                foamVFX.SetGraphicsBuffer("ParticleEmitters", particleBuffer);
                foamVFX.SetInt("ParticleCount", particleCount);
                foamVFX.SetVector3("Bounds Center", meshBounds.center);
                foamVFX.SetVector3("Bounds Size", meshBounds.size * 1.1f);
            }
            else
            {
                foamVFX.SetGraphicsBuffer("ParticleEmitters", null);
                foamVFX.SetInt("ParticleCount", 0);
            }
        }

        public void ClearParticles()
        {
            particles = Array.Empty<Structs.ParticleEmitter>();
        }

        private void DisposeVFXBuffer()
        {
            if(particleBuffer != null) particleBuffer.Dispose();
        }
        #endif
        
        #region Events
#pragma warning disable CS0067 //Event is never used
        public delegate void TriggerAction(RiverSegment segment, Collider other);
        /// <summary>
        /// Trigger callbacks.
        /// </summary>
        public static event TriggerAction onTriggerEnter, onTriggerStay, onTriggerExit;
#pragma warning restore CS0067
        
        public void OnTriggerEnter(Collider other)
        {
            onTriggerEnter?.Invoke(this, other);
        }

        public void OnTriggerStay(Collider other)
        {
            onTriggerStay?.Invoke(this, other);
        }

        public void OnTriggerExit(Collider other)
        {
            onTriggerExit?.Invoke(this, other);
        }
        #endregion

        private void OnDrawGizmosSelected()
        {
            /*
            #if UNITY_EDITOR && VFX_GRAPH
            if (UnityEditor.Selection.activeGameObject != gameObject) return;
            
            if (particles != null && particles.Length > 0)
            {
                for (int i = 0; i < particles.Length; i++)
                {
                    float3 position = this.transform.TransformPoint(particles[i].position);
                    Gizmos.DrawSphere(position, particles[i].scale * 0.5f);
                    Gizmos.DrawLine(position, position + (particles[i].velocity));
                }
            }
            #endif
            */
        }
    }
}