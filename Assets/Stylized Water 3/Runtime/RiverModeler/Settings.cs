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

namespace StylizedWater3.RiverModeler
{
    [Serializable]
    public class Settings
    {
        [Serializable]
        public struct Geometry
        {
            [Tooltip("The minimum width of the river")]
            public float baseWidth;
            
            [Min(0.1f)]
            [Tooltip("The minimum distance between the edge loops across the length of the river geometry.")]
            public float minEdgeDistance;
            [Min(0.1f)]
            [Tooltip("The minimum distance between the edge loops across the width of the river geometry." +
                     "\n\n" +
                     "A few edge loops will be needed to give the displacement effect something to work with")]
            public float widthEdgeDistance;
            
            [Min(0)]
            [Tooltip("Skip over length-wise edge loops on Spline sections that are straight")]
            public float simplifyStraight;
            public bool roundedEnds;
            
            [Range(0f, 3f)]
            [Tooltip("Adds noise-based height displacement to the vertices, emulating turbulence")]
            public float displacementStrength;
            [Min(0f)]
            public float displacementSlopeInfluence;
            [Tooltip("The distance over which the noise repeats. Lower values create largers/smoother bumps. High values create high frequency bumps.")]
            [Range(0.05f, 0.5f)]
            public float displacementScale;
            
            [Range(1f, 8f)]
            [Tooltip("Number of levels of detail to create. Resulting in lower detail meshes used in the distance")]
            public int lodLevels;
            [Range(10f, 90f)]
            [Tooltip("Percentage by which each level of detail is reduced.")]
            public float lodReduction;
            [Tooltip("Controls how quickly the mesh advances through LOD levels as camera distance increases.")]
            [Range(0.01f, 1f)]
            public float lodSelectionSlope;
            
            [Tooltip("Ignore the X and Z rotation of a spline knot so the river stays level." +
                     "\n\n" +
                     "It's recommended to rotate any knots flat instead, as other tools will still sample a twisted spline at the knot's position")]
            public bool twistCorrection;
            
            public static Geometry Default()
            {
                Geometry s = new Geometry()
                {
                    baseWidth = 10f,
                    minEdgeDistance = 1,
                    widthEdgeDistance = 1,
                    lodLevels = 4,
                    lodReduction = 50f,
                    lodSelectionSlope = 0.5f,
                    simplifyStraight = 25f,
                    displacementScale = 0.1f,
                    twistCorrection = true,
                };
                return s;
            }
        }
        public Geometry geometry = Geometry.Default();
        
        [Serializable]
        public struct FoamSettings
        {
            [Range(0f, 6f)]
            public float displacementFoam;
            
            [Min(0.1f)]
            [Range(0f, 1f)]
            public float cascadeAngleThreshold;
            [Min(0f)]
            public float cascadeAngleFalloff;
            
            [Tooltip("Enable the creation of foam/splash particles using a VFX Graph.")]
            public bool enableCascadeParticles;
            [Min(0.5f)]
            public float cascadeParticleSize;
            
            
            [Range(0f, 1f)]
            public float splashThreshold;
            public bool enableSplashParticles;
            [Min(1)]
            public int splashParticleCount;
            [Min(0.5f)]
            public float splashParticleSize;

            public float velocityStrength;
            
            public static FoamSettings Default()
            {
                FoamSettings s = new FoamSettings()
                {
                    displacementFoam = 1f,
                    enableCascadeParticles = true,
                    cascadeAngleThreshold = 10f,
                    cascadeAngleFalloff = 15f,
                    cascadeParticleSize = 1f,
                    
                    enableSplashParticles = false,
                    splashParticleCount = 3,
                    splashThreshold = 0.25f,
                    splashParticleSize = 1f,
                    
                    velocityStrength = 1f
                };
                return s;
            }
        }

        public FoamSettings foam = FoamSettings.Default();

        [Serializable]
        
        public struct Transparency
        {
            [Min(0)]
            public float startGradientFalloff;
            [Min(0)]
            public float endGradientFalloff;
            
            [Min(0)]
            public float widthGradientFalloff;
            
            public static Transparency Default()
            {
                Transparency s = new Transparency()
                {
                    startGradientFalloff = 3f,
                    endGradientFalloff = 3f,
                    widthGradientFalloff = 1f,
                };
                return s;
            }
        }
        public Transparency transparency = Transparency.Default();

        [Serializable]
        public struct Audio
        {
            public bool enable;

            [Tooltip("A profile defines the audio clips for various river sections (stream/rapid/cascade) and their ranges.")]
            public RiverAudioProfile profile;

            public static Audio Default()
            {
                Audio s = new Audio()
                {
                    enable = true,
                };

                return s;
            }
        }
        public Audio audio = Audio.Default();
        
        [Serializable]
        public struct Output
        {
            [Min(10f)]
            [Tooltip("Rivers will be split up into sections of this length. Segmenting is crucial for optimal culling/rendering performance." +
                     "\n\n" +
                     "Adjust this value according to the project needs, for instance based on streaming chunk size.")]
            public float maxSegmentLength;

            [Tooltip("If enabled, a Box Collider trigger is added to every segment. This can be used to detect if something generally nears a river." +
                     "\n\n" +
                     "Scripts can subscribe to the RiverSegment.onTriggerXXX events to detect when something enters or leaves a river segment.")]
            public bool boxTriggers;
            public bool collider;

            public static Output Default()
            {
                Output s = new Output()
                {
                    maxSegmentLength = 100,
                };
                return s;
            }
        }
        public Output output = Output.Default();
        
#if MICROVERSE
        [Serializable]
        public class MicroVerseSettings
        {
            public JBooth.MicroVerseCore.SplinePath splinePath;

            [Min(0f)]
            public float bankHeight = 0.5f;
            [Min(0.01f)]
            public float bankWidth = 5f;
            [Min(0f)] 
            public float bankFalloff = 2f;
            
            public float bankSplatWidth;
            public float bankSplatSmoothness = 3f;

            [Min(0f)]
            public float bedDepth = 2f;
            [Min(0f)]
            public float bedSmoothness = 0f;

            public float offset;
        }

        public MicroVerseSettings[] microVersePathSettings = new MicroVerseSettings[1];
#endif
    }
}