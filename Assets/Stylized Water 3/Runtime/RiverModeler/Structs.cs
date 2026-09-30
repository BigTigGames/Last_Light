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
using Unity.Mathematics;
using UnityEngine;
#if VFX_GRAPH
using UnityEngine.VFX;
#endif

namespace StylizedWater3.RiverModeler
{
    public static class Structs
    {
        [Serializable]
        public struct AudioEmitter
        {
            public enum Type
            {
                Stream,
                Rapids,
                Cascade
            }
            public Type type;
            
            public float3 position;
            
            public float minRadius;
            public float maxRadius;
        }

        public struct ConnectionInfo
        {
            public bool isValid;
            
            public float t;
            public float radius;

            public float3 position;
            public float3 normal;
        }
        
#if VFX_GRAPH
        [VFXType(VFXTypeAttribute.Usage.GraphicsBuffer)]
#endif
        [Serializable]
        public struct ParticleEmitter
        {
            //Must use Vector3, as VFX Graph doesn't support mathematics types ¯\_(ツ)_/¯
            public Vector3 position;
            public Vector3 velocity;

            public float scale;
			
            public static int GetStride()
            {
                return Unity.Collections.LowLevel.Unsafe.UnsafeUtility.SizeOf<ParticleEmitter>();
            }
        }
    }
}