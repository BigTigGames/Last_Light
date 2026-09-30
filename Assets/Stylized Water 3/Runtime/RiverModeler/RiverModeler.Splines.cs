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
using System.Linq;
using Unity.Mathematics;
using UnityEngine;
#if SPLINES
using UnityEngine.Rendering;
using UnityEngine.Splines;
#endif

namespace StylizedWater3.RiverModeler
{
    public partial class RiverModeler
    {
#if SPLINES
        [SerializeField, UnityEngine.Serialization.FormerlySerializedAs("splineContainer")]
        private SplineContainer _splineContainer;

        /// <summary>
        /// The container for which this modeler will build rivers. It can be changed through <see cref="SetSplineContainer"/>
        /// </summary>
        public SplineContainer SplineContainer
        {
            get => _splineContainer;
            private set => _splineContainer = value;
        }

        public void SetSplineContainer(SplineContainer container)
        {
            SplineContainer = container;
            //Rebuild cache?
        }

        private void SubscribeSplineCallbacks()
        {
            Spline.Changed += OnSplineChange;
            SplineContainer.SplineAdded += OnSplineAdded;
            SplineContainer.SplineRemoved += OnSplineRemoved;
        }

        private void OnSplineRemoved(SplineContainer container, int splineIndex)
        {
            if (container != _splineContainer) return;
            
            CoreUtils.Destroy(rivers[splineIndex].gameObject);
            rivers.RemoveAt(splineIndex);
        }

        private void OnSplineAdded(SplineContainer container, int splineIndex)
        {
            if (container != _splineContainer) return;
            
            Rebuild(ChangeFlags.All, splineIndex);
        }

        private void UnsubscribeSplineCallbacks()
        {
            Spline.Changed -= OnSplineChange;
        }
        
        private void OnSplineChange(Spline spline, int knotIndex, SplineModification arg3)
        {
            if (!_splineContainer) return;

            //Spline belongs to the assigned container?
            var splineIndex = Array.IndexOf(_splineContainer.Splines.ToArray(), spline);
            if (splineIndex < 0)
                return;
            
            Rebuild(ChangeFlags.All, splineIndex);
        }

        public SplineData<float4> GetScaleData(int splineIndex)
        {
            Spline sourceSpline = _splineContainer.Splines[splineIndex];
            if (!sourceSpline.TryGetFloat4Data(SCALE_DATA_KEY, out var scaleData))
            {
                sourceSpline.SetFloat4Data(SCALE_DATA_KEY, scaleData = new SplineData<float4>(1f));
                sourceSpline.TryGetFloat4Data(SCALE_DATA_KEY, out scaleData);
            }
            scaleData.DefaultValue = 1f;
            scaleData.PathIndexUnit = PathIndexUnit.Distance;

            return scaleData;
        }

        public float SampleWidth(int splineIndex, float t)
        {
            SplineData<float4> data = GetScaleData(splineIndex);
            Spline spline = _splineContainer.Splines[splineIndex];
            
            float4 value = data.Evaluate(spline, t, PathIndexUnit.Distance, RiverData<float4>.LerpFloat4Interpolator);
            
            return settings.geometry.baseWidth * value.x;
        }

        public void ResetScaleData()
        {
            int splineCount = _splineContainer.Splines.Count;
            for (int s = 0; s < splineCount; s++)
            {
                Spline spline = _splineContainer.Splines[s];

                spline.RemoveFloat4Data(RiverModeler.SCALE_DATA_KEY);
            }
        }

        /// <summary>
        /// Finds the nearest spline point to the given world position. Fairly optimized since the position is first bounds-checked against every segment. 
        /// </summary>
        /// <param name="worldPosition"></param>
        /// <param name="point"></param>
        /// <param name="tangent"></param>
        /// <param name="up"></param>
        /// <param name="t">t-value of the found position</param>
        /// <param name="sampleDistance">Distance between spline position samples. Greatly affects performance and accuracy, use the highest sensible value.</param>
        /// <returns>True if the position is at all near the river and found on the spline</returns>
        public bool FindNearestSplinePoint(float3 worldPosition, out float3 point, out float3 tangent, out float3 up, out float t, float sampleDistance = 1f)
        {
            t = -1;
            point = default;
            tangent = default;
            up = default;
            
            foreach (SplineRiver river in rivers)
            {
                if(!river) continue;
                
                foreach (RiverSegment segment in river.Segments)
                {
                    if(!segment) continue;
                    
                    if(!segment.MeshBoundsContains(worldPosition)) continue;
                    
                    if (segment.FindNearestSplinePoint(worldPosition, out point, out tangent, out up, out t,
                            sampleDistance))
                    {
                        return true;
                    };
                }
            }

            return false;
        }

        /// <summary>
        /// Finds the nearest point on the river surface to the given world position. Fairly optimized since the position is first bounds-checked against every segment. Note that this does not factor in surface displacement.
        /// </summary>
        /// <param name="worldPosition"></param>
        /// <param name="point"></param>
        /// <param name="direction"></param>
        /// <param name="normal"></param>
        /// <param name="t">t-value of the found position</param>
        /// <param name="sampleDistance">Distance between spline position samples. Greatly affects performance and accuracy, use the highest sensible value.</param>
        /// <returns></returns>
        public bool FindNearestPointOnRiver(float3 worldPosition, out float3 point, out float3 direction, out float3 normal, out float t, float sampleDistance = 1f)
        {
            t = -1;
            point = default;
            direction = default;
            normal = default;
            
            foreach (SplineRiver river in rivers)
            {
                if(!river) continue;
                
                foreach (RiverSegment segment in river.Segments)
                {
                    if(!segment) continue;
                    
                    if(!segment.MeshBoundsContains(worldPosition)) continue;
                    
                    if (segment.FindNearestPointOnRiver(worldPosition, out point, out direction, out normal, out t, sampleDistance))
                    {
                        return true;
                    };
                }
            }

            return false;
        }
        
        /// <summary>
        /// Checks if the given position is within the river width and on or under the river surface.
        /// </summary>
        /// <param name="splineT"></param>
        /// <param name="splineIndex"></param>
        /// <param name="targetPosition"></param>
        /// <param name="splinePosition"></param>
        /// <param name="splineForward"></param>
        /// <param name="splineUp"></param>
        /// <returns></returns>
        public bool IsOnOrUnderRiverSurface(float splineT, int splineIndex, float3 targetPosition, float3 splinePosition, float3 splineForward, float3 splineUp)
        {
            float width = SampleWidth(splineIndex, splineT);
                
            float3 right = math.normalize(math.cross(splineForward, splineUp));
                
            //Given the position, width and 'right' direction, check if the object is on or under the river surface
            float3 offsetFromCenter = targetPosition - splinePosition;
            float distanceFromCenter = math.abs(math.dot(offsetFromCenter, right));
            bool isWithinRiverWidth = distanceFromCenter <= width;
            bool isOnOrUnderSurface = targetPosition.y <= splinePosition.y;
            
            return isWithinRiverWidth && isOnOrUnderSurface;
        }
#endif
    }
}