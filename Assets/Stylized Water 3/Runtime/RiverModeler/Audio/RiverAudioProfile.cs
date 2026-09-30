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
using UnityEngine;
using UnityEngine.Audio;

namespace StylizedWater3.RiverModeler
{
    [CreateAssetMenu(fileName = "River Audio Profile", menuName = "Water/River Audio Profile", order = 0)]
    public class RiverAudioProfile : ScriptableObject
    {
        [Serializable]
        public class AudioLoop
        {
            public AudioClip clip;
            [Range(0f, 1f)] public float volume = 1f;

            [Range(0f, 20f)] public float pitchVariation = 10f;
            [Min(1f)] public float audibleDistance = 20f;
        }

        public AudioLoop stream = new AudioLoop();
        public AudioLoop rapids = new AudioLoop();
        public AudioLoop cascade = new AudioLoop();

        [Space]
        
        public AudioMixerGroup mixerGroup;

#if UNITY_EDITOR
        public static RiverAudioProfile LoadDefaultInEditor()
        {
            string path = UnityEditor.AssetDatabase.GUIDToAssetPath("e9ace19bb6e908b4cbd7c50e42dc41c7");
            RiverAudioProfile profile = UnityEditor.AssetDatabase.LoadAssetAtPath<RiverAudioProfile>(path);

            return profile;
        }
        
        private void OnValidate()
        {
            AudioClip LoadAudioClip(string guid)
            {
                string path = UnityEditor.AssetDatabase.GUIDToAssetPath(guid);
                    
                if(string.IsNullOrEmpty(path)) return null;
                    
                return UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(path);
            }

            //Load defaults
            if (stream.clip == null) stream.clip = LoadAudioClip("68b2825bfd109ac45ad543b73245f1b8");
            if (rapids.clip == null) rapids.clip = LoadAudioClip("2abeef0b96f78b649817f0c2d3373946");
            if (cascade.clip == null) cascade.clip = LoadAudioClip("72368034c2551a24fbb9168d327a1b41");
        }
#endif
    }
}