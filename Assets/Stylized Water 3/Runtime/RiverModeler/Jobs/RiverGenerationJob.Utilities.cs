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

using Unity.Mathematics;
using UnityEngine;

namespace StylizedWater3.RiverModeler
{
    public partial struct RiverGenerationJob
    {
        private const float DISPLACEMENT_NORMAL_STRENGTH = 8;
        
        private float CalculateSlopeMask(float3 normalWS, float threshold, float falloff)
        {
            float surfaceAngle = ((float)math.acos(math.dot(normalWS, math.up())) * Mathf.Rad2Deg);

            float start = surfaceAngle - threshold;
            float end = threshold - math.max(0.001f, falloff);
	
            return math.saturate((end - start) / (end - threshold));
        }

        private float FadeIntersection(Structs.ConnectionInfo connection, float3 vertexPosition)
        {
            if (connection.isValid == false) return 0f;
            
            float3 connectionNormal = connection.normal;
            float3 intersectionThreshold = connection.position;

            float side = math.dot(vertexPosition - intersectionThreshold, -connectionNormal);
            float fadeDistance = math.max(connection.radius * 0.15f, 0.0001f);
            
            //if(math.distance(connection.position, vertexPosition) > connection.radius * 2f) return 0f;
            
            float linearFade = 1f-math.saturate(1f - (side / fadeDistance));
            
            float noise = Unity.Mathematics.noise.cnoise(new float2(vertexPosition.x, vertexPosition.z) * 10f);
            float intersectionFade = math.saturate(linearFade + noise) * linearFade;

            return math.saturate(intersectionFade);
        }
        
        private void ProcessIntersection(Structs.ConnectionInfo connectionInfo, float3x3 rotationMatrix, float3 localPosition, float3 scale, ref float3 splinePosition, ref float3 vertexPosition,
            ref float alpha)
        {
            float blend = FadeIntersection(connectionInfo, vertexPosition);
            //Blend in the start connection
            splinePosition.y = math.lerp(splinePosition.y, connectionInfo.position.y, blend);
                            
            //Recalculate
            vertexPosition = splinePosition + math.mul(rotationMatrix, localPosition * scale);
                            
            alpha += blend;
        }

        private static void CalculateDisplacement(float x, float y, float2 stride, float scale, float strength, out float height, out float3 normal, out float3 tangent)
        {
            height = noise.snoise(new float2(x, y) * scale) * strength;
            
            float noiseLeft = noise.snoise(new float2(x - stride.x, y) * scale) * strength * DISPLACEMENT_NORMAL_STRENGTH;
            float noiseRight = noise.snoise(new float2(x + stride.x, y) * scale) * strength * DISPLACEMENT_NORMAL_STRENGTH;

            float noiseBack = noise.snoise(new float2(x, y - stride.y) * scale) * strength * DISPLACEMENT_NORMAL_STRENGTH;
            float noiseForward = noise.snoise(new float2(x, y + stride.y) * scale) * strength * DISPLACEMENT_NORMAL_STRENGTH;
            
            float dhdx = (noiseRight - noiseLeft);
            float dhdz = (noiseForward - noiseBack);
            
            normal = math.normalize(new float3(-dhdx, 1f, -dhdz));
            tangent = math.normalize(new float3(1f, dhdx / DISPLACEMENT_NORMAL_STRENGTH, 0f));
        }
        
        public static float EaseInOut(float t)
        {
            float eased = 2f * t * t;
            if (t > 0.5f) eased = 4f * t - eased - 1f;
                            
            return eased;
        }
        
        public static float CalculateDistanceWeight(float position, float surfaceLength, float startDistance, float startFalloff, float endDistance, float endFalloff, bool invert, bool easeInOut = false)
        {
            float start = math.saturate(((startDistance) - (position - (startDistance + startFalloff))) / (math.max(startFalloff, 0.00001f)));
            float end = math.saturate(((surfaceLength - endDistance) - (position + endDistance)) / (math.max(endFalloff, 0.00001f)));

            //Patch when falloff is 0
            if(endFalloff == 0f && (position - surfaceLength) <= 0f) end = 1f;
            
            float gradient = math.max(start, 1f- end);

            if (easeInOut)
            {
                gradient = EaseInOut(gradient);
            }
            
            if(invert) gradient = 1f-gradient;
            
            return gradient;
        }
        
        public static float EdgeDistanceMask(float position, float maxWidth, float distance)
        {
            if (distance <= 0f) return 0f;

            float halfWidth = maxWidth * 0.5f;
            float distanceFromEdge = halfWidth - math.abs(position);

            return math.saturate((distance - distanceFromEdge) / distance);
        }
        
        public static quaternion LockRotationZ(quaternion neutralRotation, quaternion targetRotation)
        {
            math.RotationOrder rotationOrder = math.RotationOrder.ZXY;
            
            float3 prevEuler = math.Euler(neutralRotation, rotationOrder);
            float3 newEuler = math.Euler(targetRotation, rotationOrder);
                
            //Note: Angles are in radians
            newEuler.z = prevEuler.z;
            
            quaternion newRotation = quaternion.Euler(newEuler, rotationOrder);

            return newRotation;
        }
        
        public static float CalculateCurvatureAngle(float3 prevTangent, float3 tangent)
        {
            //Calculate curvature by measuring the angle change between tangents
            float delta = math.clamp(math.dot(math.normalize(prevTangent), math.normalize(tangent)), -1f, 1f);
            float r = math.acos(delta);
            float angle = math.abs(math.degrees(r));

            return angle;
        }
        
        public static float CalculateSlopeAngle(float3 normal)
        {
            return ((float)math.acos(math.dot(normal, math.up())) * Mathf.Rad2Deg);
        }
    }
}