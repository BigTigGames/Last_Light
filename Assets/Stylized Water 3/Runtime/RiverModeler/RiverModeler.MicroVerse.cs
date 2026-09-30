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
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Profiling;
#if SPLINES
using UnityEngine.Splines;
#endif

#if MICROVERSE
using SplinePath = JBooth.MicroVerseCore.SplinePath;
#endif

#if MICROVERSE
namespace StylizedWater3.RiverModeler
{
    public partial class RiverModeler
    {
        //Unused code warnings
#pragma warning disable CS0162
        //A bit of padding to ensure that the river geometry at least clips through the terrain
        private const float MV_WIDTH_PADDING = 0.25f;
        private const float MV_MIN_SMOOTHNESS = 1f;
        
        #pragma warning restore CS0162
        
        partial void UpdateMicroVerseSplines()
        {
            #if MICROVERSE && SPLINES && UNITY_EDITOR
            if (!SplineContainer) return;

            Profiler.BeginSample($"River Modeler: MicroVerse Spline Update");
            
            var riverWidth = this.settings.geometry.baseWidth;
            float halfWidth = (riverWidth * 0.5f) - MV_WIDTH_PADDING;
            
            foreach (Settings.MicroVerseSettings setting in settings.microVersePathSettings)
            {
                if (setting == null) continue;
                
                SplinePath splinePath = setting.splinePath;

                if (!splinePath) continue;
                
                if (splinePath.modifyHeightMap == false && splinePath.modifySplatMap == false)
                {
                    return;
                }
                
                var m_offset = setting.offset;
                var m_bankWidth = setting.bankWidth;
                
                if (splinePath.modifyHeightMap)
                {
                    Keyframe[] heightCurveKeyframes = new Keyframe[3];
                    heightCurveKeyframes[0].time = 0f;
                    heightCurveKeyframes[0].value = setting.bedDepth;

                    heightCurveKeyframes[1].time = math.max(0.02f, setting.bedSmoothness / riverWidth);
                    heightCurveKeyframes[1].value = -setting.bankHeight;

                    heightCurveKeyframes[2].time = 1f;
                    heightCurveKeyframes[2].value = 0f;
                    
                    splinePath.trench = 0f;
                    splinePath.useTrenchCurve = true;
                    
                    splinePath.trenchCurve = new AnimationCurve(heightCurveKeyframes);
                    splinePath.ClearCachedSplineTrenchCurve();

                    m_bankWidth += setting.bedSmoothness;
                    splinePath.width = m_bankWidth;
                    splinePath.smoothness = MV_MIN_SMOOTHNESS + setting.bankFalloff;

                    //Counter so that the smoothness only appears to go inwards
                    m_offset -= setting.bedSmoothness;
                    m_offset -= setting.bankFalloff * 0.1f;
                }

                if (splinePath.modifySplatMap)
                {
                    splinePath.splatWidth = setting.bankSplatWidth;
                    splinePath.splatSmoothness = setting.bankSplatSmoothness;
                }

                //Copy the Scale (Width+Displacement) data into the spline's width data
                splinePath.splineWidths = new List<SplinePath.SplineWidthData>();

                int splineCount = SplineContainer.Splines.Count;

                for (int splineIndex = 0; splineIndex < splineCount; splineIndex++)
                {
                    SplinePath.SplineWidthData outWidth = new SplinePath.SplineWidthData();
                    outWidth.widthData.PathIndexUnit = PathIndexUnit.Distance;
                    
                    SplineData<float4> scaleData = GetScaleData(splineIndex);
                    
                    int dataPointCount = scaleData.Count;

                    for (int i = 0; i < dataPointCount; i++)
                    {
                        outWidth.widthData.Add(scaleData[i].Index, scaleData[i].Value.x * halfWidth - -m_offset);
                    }
                    splinePath.splineWidths.Add(outWidth);
                }
            
                //Force an update
                splinePath.OnMoved();
            }
            
            Profiler.EndSample();
            #endif
        }
    }
}
#endif