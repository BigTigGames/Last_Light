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
using Unity.Jobs;
using Random = Unity.Mathematics.Random;
#if SPLINES
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Splines;
using UnityEngine.VFX;

namespace StylizedWater3.RiverModeler
{
    public partial struct RiverGenerationJob : IJob
    {
        private const float SAMPLE_DISTANCE = 0.5f;
        
        //Spline
        [ReadOnly] private NativeSpline spline;
        [ReadOnly] private float splineLength;
        float2 curveRange;
        private float curveLength;
        float minT, maxT;
        private int sampleCount;
        
        private Structs.ConnectionInfo startConnection;
        private Structs.ConnectionInfo endConnection;

        private Random random;

        //Settings
        private float baseWidth;
        private int widthSegments;
        
        //Transforms
        private float3 positionOffset; //Value used to center the pivot
        private float4x4 rendererWorldToLocal;
        private float3x3 normalTransform;

        [ReadOnly] private RiverData<float4> scaleData;

        private bool isFirstSegment;
        private bool isLastSegment;
        
        struct Vertex
        {
            public float3 position;
            public float3 normal;
            public float4 tangent;
            public float4 color;
            public float4 uv0;
            public float4 uv1;
        }
        
        public static readonly VertexAttributeDescriptor[] VertexAttributes = new VertexAttributeDescriptor[]
        {
            new (VertexAttribute.Position, VertexAttributeFormat.Float32, 3),
            new (VertexAttribute.Normal, VertexAttributeFormat.Float32, 3),
            new (VertexAttribute.Tangent, VertexAttributeFormat.Float32, 4),
            new (VertexAttribute.Color, VertexAttributeFormat.Float32, 4),
            new (VertexAttribute.TexCoord0, VertexAttributeFormat.Float32, 4),
            new (VertexAttribute.TexCoord1, VertexAttributeFormat.Float32, 4),
        };
        
        //Output
        private NativeList<Vertex> vertices;
        private NativeList<ushort> indices;
#if UNITY_6000_2_OR_NEWER
        private NativeArray<uint2> lodIndexRanges;
#endif
        private NativeArray<float3> metaData;

        private float3 currentBoundsMin;
        private float3 currentBoundsMax;
        private float3 boundsMin => metaData[0];
        private float3 boundsMax => metaData[1];
        public float3 pivotOffset => metaData[2];
        
        #if VFX_GRAPH
        public NativeList<Structs.ParticleEmitter> particles;
        #endif
        
        public NativeList<Structs.AudioEmitter> audioEmitters;
        
        //Settings
        private Settings.Geometry geometrySettings;
        private Settings.FoamSettings foamSettings;
        private Settings.Transparency transparencySettings;
        
        private float streamAudioRange, rapidsAudioRange, cascadeAudioRange;
        
        public void Setup(NativeSpline nativeSpline, Structs.ConnectionInfo startConnection, Structs.ConnectionInfo endConnection, Matrix4x4 outputWorldToLocal, Vector2 splineCurveRange, Settings settings, RiverData<float4> scaleData)
        {
            this.spline = nativeSpline;
            splineLength = nativeSpline.GetLength();
            this.curveRange = splineCurveRange;
            this.curveLength = curveRange.y - curveRange.x;
            
            isFirstSegment = curveRange.x == 0f;
            isLastSegment = curveRange.y >= splineLength -1f;
            
            minT = Mathf.Max(0.0001f, curveRange.x / splineLength);
            maxT = Mathf.Min(0.9999f, curveRange.y / splineLength);

            random = new Unity.Mathematics.Random(1337);
            
            baseWidth = settings.geometry.baseWidth;
            
            this.geometrySettings = settings.geometry;
            this.foamSettings = settings.foam;
            this.transparencySettings = settings.transparency;
            
            this.startConnection = startConnection;
            this.endConnection = endConnection;
            
            this.scaleData = scaleData;
            
            //Audio
            if (settings.audio.profile)
            {
                streamAudioRange = settings.audio.profile.stream.audibleDistance;
                rapidsAudioRange = settings.audio.profile.rapids.audibleDistance;
                cascadeAudioRange = settings.audio.profile.cascade.audibleDistance;
            }
            
            float widthEdgeDistance = Mathf.Max(0.1f, settings.geometry.widthEdgeDistance);
            widthSegments = Mathf.CeilToInt(baseWidth / widthEdgeDistance);
            widthSegments = (int)Mathf.Clamp(widthSegments, 1, 100);
            
            float minEdgeDistance = Mathf.Max(0.1f, settings.geometry.minEdgeDistance);
            sampleCount = Mathf.Max(2, Mathf.CeilToInt(curveLength / SAMPLE_DISTANCE));
            
            //Debug.Log($"River Modeler: Sample count: {sampleCount} over {curveLength}m between {curveRange}");
            
            //Matrix to convert the world-space vertices into local-space again
            rendererWorldToLocal = outputWorldToLocal;
            normalTransform = new float3x3(math.normalize(rendererWorldToLocal.c0.xyz), math.normalize(rendererWorldToLocal.c1.xyz), math.normalize(rendererWorldToLocal.c2.xyz));
            
            vertices = new NativeList<Vertex>(sampleCount * widthSegments, Allocator.Persistent);
            metaData = new NativeArray<float3>(3, Allocator.Persistent);
            
            int estimatedIndexCount = (sampleCount - 1) * widthSegments * 6;
#if UNITY_6000_2_OR_NEWER
            lodIndexRanges = new NativeArray<uint2>(geometrySettings.lodLevels, Allocator.Persistent);
            if (geometrySettings.lodLevels > 1)
            {
                estimatedIndexCount *= geometrySettings.lodLevels;
            }
#endif
            indices = new NativeList<ushort>(estimatedIndexCount, Allocator.Persistent);
            
#if VFX_GRAPH
            particles = new NativeList<Structs.ParticleEmitter>(sampleCount, Allocator.Persistent);
#endif
            audioEmitters = new NativeList<Structs.AudioEmitter>(sampleCount,Allocator.Persistent);
        }
        
        private float3 CalculateCurveCenter()
        {
            int boundsSampleIterations = 2;
            
            float3 curveBoundsMin = new float3(float.MaxValue);
            float3 curveBoundsMax = new float3(float.MinValue);
            for (int i = 0; i < boundsSampleIterations; i++)
            {
                float t = (float)i / (boundsSampleIterations-1);
                
                t = math.lerp(minT, maxT, t);

                float3 curvePos = spline.EvaluatePosition(t);
 
                curveBoundsMin = math.min(curveBoundsMin, curvePos);
                curveBoundsMax = math.max(curveBoundsMax, curvePos);
            }
            
            return (curveBoundsMin + curveBoundsMax) * 0.5f;
        }
        
        public void Execute()
        {
            int lastRowVertexStart = -1;
            int rowVertexCount = widthSegments + 1;
            
            float lastRowPosition = -1f;
            float lastCascadeRowPosition = -1f;
            float rowStride = 1f / sampleCount;
            float3 nextTangent = float3.zero;
            float3 baseVertexTangent = new float3(1, 0, 0);

            float lastAudioPosition = -1f;
            Structs.AudioEmitter.Type lastAudioType = Structs.AudioEmitter.Type.Stream;

            float turbulence = 0;
            float capOffset = 0;
            float baseParticleVelocity = foamSettings.velocityStrength * 1000f;
            
            //Offset required to center the pivot point (in object-space), must be set afterwards as the GameObject's local position
            positionOffset = math.mul(rendererWorldToLocal, new float4(CalculateCurveCenter(), 1f)).xyz;

            float startFadeLength = startConnection.isValid ? 0 : transparencySettings.startGradientFalloff;
            float endFadeLength = endConnection.isValid ? 0 : transparencySettings.endGradientFalloff;

            float flatFilter = geometrySettings.simplifyStraight * 0.01f;
            
            int rowCount = 0;
            for (int y = 0; y < sampleCount; y++)
            {
                float segmentT = (float)y / (float)(sampleCount - 1);
                float t = math.lerp(minT, maxT, segmentT);
                
                //Clamp t to respect both start (curveRange.x) and end (curveRange.y) trimming
                t = math.clamp(t, minT, maxT);
                
                float distance = math.lerp(curveRange.x, curveRange.y, segmentT); //Position in metric units
                
                spline.Evaluate(t, out float3 splinePosition, out float3 tangent, out float3 splineUp);
                float3 forward = math.normalize(tangent);
                float3 right = math.normalize(math.cross(splineUp, forward));
                
                //Always create an edge loop at the very start & end.
                bool isEndpointRow = y == 0 || y == sampleCount - 1;
                //If current distance at sampling point crosses the desired threshold
                bool reachedMinimumDistance = (distance - lastRowPosition) >= geometrySettings.minEdgeDistance;

                quaternion rotation = quaternion.LookRotationSafe(forward, splineUp);
                if(geometrySettings.twistCorrection) rotation = LockRotationZ(quaternion.identity, rotation);
                float3x3 rotationMatrix = new float3x3(rotation);
                
                float3 scale = new float3(1f, 1f, 1f);

                float displacementToolAdd = 0f;
                if (scaleData.HasData)
                {
                    float4 splineScale = scaleData.Evaluate(spline, t, true);
                    displacementToolAdd = splineScale.y - 1f;
                    scale *= splineScale.xyz;
                }
                float scaledWidth = baseWidth * scale.x;
                float widthStride = geometrySettings.widthEdgeDistance / scaledWidth;
                float halfWidth = scaledWidth * 0.5f;

                nextTangent = spline.EvaluateTangent(t + (rowStride * 3f));
                float curvatureAngle = CalculateCurvatureAngle(nextTangent, tangent);

                //Debug.Log($"Curvature at {t}: {curvatureAngle}");
                bool createVertexRow = isEndpointRow || (reachedMinimumDistance && curvatureAngle >= flatFilter);
                
                float slope = CalculateSlopeAngle(splineUp);

                float alpha = 0f;

                float cascadeWeight = CalculateSlopeMask(splineUp, foamSettings.cascadeAngleThreshold, foamSettings.cascadeAngleFalloff);
                bool createParticleRow = cascadeWeight > 0.25f && ((distance - lastCascadeRowPosition) >= foamSettings.cascadeParticleSize * 0.5f);
                
                //createRow = true;
                if (createVertexRow)
                {
                    float3 splineNormal = math.mul(rotationMatrix, splineUp);
                    splineNormal = math.normalize(math.mul(normalTransform, splineNormal));
                    float3 vertexNormal = splineNormal;
                    float3 vertexTangent = baseVertexTangent;
                    
                    int currentRowVertexStart = vertices.Length;
                    
                    bool firstRow = isFirstSegment && y == 0 && !startConnection.isValid;
                    bool lastRow = isLastSegment && y == sampleCount - 1 && !endConnection.isValid;
                    
                    for (int x = 0; x <= widthSegments; x++)
                    {
                        float xt = (float)x / (widthSegments);

                        float3 localPosition = new float3(x * (baseWidth / widthSegments) - (baseWidth * 0.5f), 0, 0);

                        if (geometrySettings.roundedEnds)
                        {
                            float xCircle = (localPosition.x / halfWidth) * halfWidth;
                            capOffset = math.sqrt(halfWidth * halfWidth - xCircle * xCircle);

                            //Create rounded caps
                            if (firstRow)
                            {
                                localPosition.z = -capOffset;
                            }

                            if (lastRow)
                            {
                                localPosition.z = capOffset;
                            }
                        }

                        //Vertex color gradients
                        float tipGradient = CalculateDistanceWeight(t * curveLength, curveLength + (1f/curveLength),
                            0, startFadeLength,
                            0, endFadeLength, false, false);
                        float widthGradient = EdgeDistanceMask(localPosition.x * scale.x, scaledWidth, transparencySettings.widthGradientFalloff);

                        if (isLastSegment)
                        {
                            //Enforce an alpha fade at the edges of the river
                            //tipGradient = math.saturate(tipGradient);
                            //widthGradient = math.saturate(widthGradient);
                        }
                        
                        //alpha = math.max(tipGradient, widthGradient);
                        alpha = math.saturate(tipGradient + widthGradient);
                        
                        float displacementStrength = (geometrySettings.displacementStrength + (geometrySettings.displacementSlopeInfluence * slope * 0.1f) + displacementToolAdd) * (1f - alpha) * (1f - cascadeWeight);
                        if (displacementStrength > 0)
                        {
                            float2 displacementCoords = new float2(localPosition.x, distance);
                            
                            CalculateDisplacement(displacementCoords.x, displacementCoords.y,
                                new float2(1f / widthSegments, rowStride),
                                geometrySettings.displacementScale, displacementStrength * scale.y,
                                out var displacement, out var displacementNormal, out var displacementTangent);

                            //Local-space of mesh
                            localPosition.y += displacement;

                            float absDisplacement = math.abs(displacement);
                            if (absDisplacement > 0)
                            {
                                float displacementBlend = math.saturate(absDisplacement);
                                
                                float3 displacementNormalWS = math.mul(rotationMatrix, displacementNormal);
                                float3 displacementNormalLS = math.normalize(math.mul(normalTransform, displacementNormalWS));

                                float3 displacementTangentWS = math.mul(rotationMatrix, displacementTangent);
                                float3 displacementTangentLS = math.normalize(math.mul(normalTransform, displacementTangentWS));

                                //Blend with spline curve normal (both local-space vectors)
                                vertexNormal = math.normalize(math.lerp(splineNormal, displacementNormalLS, displacementBlend));
                                vertexTangent = math.normalize(math.lerp(vertexTangent, displacementTangentLS, displacementBlend));
                            }
                        }

                        //Transform vertex to world space using the spline point and rotation
                        float3 vertexPositionWorld = splinePosition + math.mul(rotationMatrix, localPosition * scale);
                        
                        //Spline is connected to another river, calculate intersection weight for vertex
                        //Alpha fades out where it overlaps
                        if (isFirstSegment && startConnection.isValid)
                        {
                            ProcessIntersection(startConnection, rotationMatrix, localPosition, scale, ref splinePosition, ref vertexPositionWorld, ref alpha);
                        }

                        if (isLastSegment && endConnection.isValid)
                        {
                            ProcessIntersection(endConnection, rotationMatrix, localPosition, scale, ref splinePosition, ref vertexPositionWorld, ref alpha);
                        }
                        alpha = math.saturate(alpha);
                        
                        //Always make the start and end edges transparent
                        if(isFirstSegment && y == 0) alpha = 1f;
                        if(isLastSegment && y == sampleCount - 1) alpha = 1f;
                        
                        float slopeFoam = cascadeWeight;
                        slopeFoam *= 1f-alpha;
                        
                        turbulence = math.saturate(localPosition.y);

                        float foam = math.saturate(turbulence * foamSettings.displacementFoam - cascadeWeight);
                        
                        //World-space to the local-space position of the mesh filter
                        float3 vertexPositionLocal = math.mul(rendererWorldToLocal, new float4(vertexPositionWorld - positionOffset, 1.0f)).xyz;
                        
#if VFX_GRAPH
                        if(foamSettings.enableSplashParticles && createParticleRow == false && turbulence > foamSettings.splashThreshold && alpha < 1f)
                        {
                            Structs.ParticleEmitter particle = new Structs.ParticleEmitter()
                            {
                                position = vertexPositionLocal - (math.up() * foamSettings.splashParticleSize * 0.5f),
                                velocity = math.up() * -1f,
                                //normal = splineUp,
                                scale = foamSettings.splashParticleSize
                            };
                            particles.Add(particle);

                            for (int i = 0; i < foamSettings.splashParticleCount; i++)
                            {
                                particle.position += (Vector3)random.NextFloat3Direction() * foamSettings.splashParticleSize * 0.5f;
                                particles.Add(particle);
                            }
                        }
#endif
                        
                        //Extend bounds as it expands in local-space
                        currentBoundsMin = math.min(vertexPositionLocal, currentBoundsMin);
                        currentBoundsMax = math.max(vertexPositionLocal, currentBoundsMax);

                        float2 uv = new float2(-xt * scaledWidth, -t * splineLength);

                        if (geometrySettings.roundedEnds)
                        {
                            //Counter stretching created by end cap
                            if (firstRow)
                            {
                                uv.y = capOffset;
                            }

                            if (lastRow)
                            {
                                uv.y -= capOffset;
                            }
                        }

                        //Normalized UV coordinates for lightmap
                        float ratio = (scaledWidth / curveLength);
                        float2 lightmapUV = new float2((localPosition.x * widthStride * ratio) + 0.5f, segmentT);
                        
                        //float3 tangentLS = math.mul(rendererWorldToLocal, new float4(forward, 0.0f)).xyz;

                        float waveFlattening = math.saturate(1f - (slopeFoam + turbulence)) * 0.75f;
                        Vertex vertex = new Vertex()
                        {
                            position = vertexPositionLocal,
                            normal = vertexNormal,
                            tangent = new float4(-vertexTangent, 1f),
                            uv0 = new float4(uv.x, uv.y, math.saturate(slopeFoam * 2f), alpha),
                            uv1 = new float4(lightmapUV.xy, 0f, 0f),
                            color = new float4(widthGradient, alpha, waveFlattening, foam)
                        };
                        vertices.Add(vertex);
                    }
                    
                    //Create triangles for row
                    if (lastRowVertexStart >= 0)
                    {
                        for (int x = 0; x < widthSegments; x++)
                        {
                            ushort previousLeft = (ushort)(lastRowVertexStart + x);
                            ushort previousRight = (ushort)(previousLeft + 1);
                            ushort currentLeft = (ushort)(currentRowVertexStart + x);
                            ushort currentRight = (ushort)(currentLeft + 1);

                            indices.Add(previousLeft);
                            indices.Add(currentLeft);
                            indices.Add(previousRight);

                            indices.Add(previousRight);
                            indices.Add(currentLeft);
                            indices.Add(currentRight);
                        }
                    }
                    
                    lastRowVertexStart = currentRowVertexStart;
                    lastRowPosition = distance;

                    rowCount++;
                }
                
                #if VFX_GRAPH
                //Create cascade effect
                if (createParticleRow && foamSettings.enableCascadeParticles)
                {
                    int particlesInRow = Mathf.CeilToInt(scaledWidth / foamSettings.cascadeParticleSize * 2f);
                    
                    float margin = foamSettings.cascadeParticleSize;
                    float particleStripWidth = scaledWidth / particlesInRow;
                    for (int x = 0; x < particlesInRow; x++)
                    {
                        float xt = (float)x / (particlesInRow);

                        float3 localPosition = new Vector3(x * particleStripWidth - (halfWidth), 0, 0);

                        if(localPosition.x + halfWidth < margin || localPosition.x + halfWidth > (scaledWidth - margin)) continue;
                        
                        //Move back a bit to give particles some runway to shoot forward
                        float3 splineParticlePoint = splinePosition - (forward * math.max(1, foamSettings.velocityStrength * 2f));
                        //Sink slightly into river
                        //splineParticlePoint -= (up * particleScale * 0.25f);
                        
                        //Transform vertex to spline point and rotation (spline's local-space)
                        float3 vertexPosition = splineParticlePoint + math.mul(rotationMatrix, localPosition);
                        //Make that the local-space position of the mesh filter
                        vertexPosition = math.mul(rendererWorldToLocal, new float4(vertexPosition, 1.0f)).xyz - positionOffset;

                        //float3 localForward = math.mul(rendererWorldToLocal, new float4(forward, 0)).xyz;
                        Structs.ParticleEmitter particle = new Structs.ParticleEmitter()
                        {
                            position = vertexPosition,
                            velocity = forward * rowStride * baseParticleVelocity,
                            //normal = splineUp,
                            scale = foamSettings.cascadeParticleSize
                        };
                        particles.Add(particle);
                    }

                    lastCascadeRowPosition = distance;
                }
                #endif

                //Audio
                Structs.AudioEmitter.Type currentAudioType;
                float audioRange = scaledWidth;
                if (slope >= foamSettings.cascadeAngleThreshold)
                {
                    currentAudioType = Structs.AudioEmitter.Type.Cascade;
                    audioRange += cascadeAudioRange;
                }
                else if (turbulence > 0.1)
                {
                    currentAudioType = Structs.AudioEmitter.Type.Rapids;
                    audioRange += rapidsAudioRange;
                }
                else
                {
                    currentAudioType = Structs.AudioEmitter.Type.Stream;
                    audioRange += streamAudioRange;
                }
                
                //Create an audio emitter if it is far away from the last, or it is a different audio type
                if ((distance - lastAudioPosition) > audioRange || currentAudioType != lastAudioType)
                {
                    Structs.AudioEmitter emitter = new Structs.AudioEmitter();
                    
                    emitter.position = splinePosition;
                    
                    emitter.minRadius = scaledWidth;
                    emitter.maxRadius = audioRange;
                    emitter.type = currentAudioType;
                    
                    audioEmitters.Add(emitter);
                    
                    lastAudioPosition = distance;
                    lastAudioType = currentAudioType;
                }
            }
            
#if UNITY_6000_2_OR_NEWER
            //With the mesh now generated, create extra LOD levels. Each LOD skips over a vertex for a triangle
            GenerateLodIndices(rowCount, rowVertexCount);
#endif
            
            metaData[0] = currentBoundsMin;
            metaData[1] = currentBoundsMax;
            metaData[2] = positionOffset;
        }
        
#if UNITY_6000_2_OR_NEWER
private void GenerateLodIndices(int rowCount, int rowVertexCount)
        {
            if(geometrySettings.lodLevels <= 1) return;
        
            lodIndexRanges[0] = new uint2(0, (uint)indices.Length);

            float keepFraction = 1f - (geometrySettings.lodReduction * 0.01f);
            int vertexSkip = (int)math.max(1, math.round(1f / keepFraction));
        
            for (int lod = 1; lod < geometrySettings.lodLevels; lod++)
            {
                int indexStart = indices.Length;
                int step = lod + vertexSkip;

                for (int y = 0; y < rowCount - 1; y += step)
                {
                    int nextY = math.min(y + step, rowCount - 1);

                    if (nextY == y) continue;

                    int previousRowVertexStart = y * rowVertexCount;
                    int currentRowVertexStart = nextY * rowVertexCount;

                    //Preserve the left edge gradient: first -> second vertex.
                    AddLodQuad(previousRowVertexStart, currentRowVertexStart, 0, math.min(1, widthSegments));

                    //Simplify only the interior, between the preserved edge-gradient vertices.
                    int x = 1;
                    int interiorEnd = math.max(1, widthSegments - 1);

                    while (x < interiorEnd)
                    {
                        int nextX = math.min(x + step, interiorEnd);

                        if (nextX == x) break;

                        AddLodQuad(previousRowVertexStart, currentRowVertexStart, x, nextX);
                        x = nextX;
                    }

                    // Preserve the right edge gradient: second-last -> last vertex.
                    if (widthSegments > 1)
                    {
                        AddLodQuad(previousRowVertexStart, currentRowVertexStart, widthSegments - 1, widthSegments);
                    }
                }

                lodIndexRanges[lod] = new uint2((uint)indexStart, (uint)(indices.Length - indexStart));
            }
        }

        private void AddLodQuad(int previousRowVertexStart, int currentRowVertexStart, int leftX, int rightX)
        {
            if (rightX <= leftX) return;

            ushort previousLeft = (ushort)(previousRowVertexStart + leftX);
            ushort previousRight = (ushort)(previousRowVertexStart + rightX);
            ushort currentLeft = (ushort)(currentRowVertexStart + leftX);
            ushort currentRight = (ushort)(currentRowVertexStart + rightX);

            indices.Add(previousLeft);
            indices.Add(currentLeft);
            indices.Add(previousRight);

            indices.Add(previousRight);
            indices.Add(currentLeft);
            indices.Add(currentRight);
        }
#endif
        
        //Default flags to use, where all validation is disabled. Best performance, but requires data to be absolutely correct.
        public const MeshUpdateFlags MeshValidationFlags = MeshUpdateFlags.DontRecalculateBounds | MeshUpdateFlags.DontValidateIndices | MeshUpdateFlags.DontResetBoneBounds;

        public Mesh CreateMesh(ref Mesh mesh, bool readable = true)
        {
            if (Application.isPlaying) readable = true;
            
#if UNITY_EDITOR
            //Destroy and recreate if readable state doesn't match
            if (mesh.isReadable != readable)
            {
                CoreUtils.Destroy(mesh);
                mesh = new Mesh();
                
#if SWS_DEV
                //Debug.Log($"River Modeler: Recreated mesh at index {index}. Read state changed to {readable}");
#endif
            }
#endif
            
#if UNITY_6000_2_OR_NEWER
            int currentLodCount = mesh.lodCount;

            //Clear existing LODs, otherwise setting submeshes leads to targeting out-of-range indices if the mesh has fewer triangles than before
            if (currentLodCount > 0)
            {
                mesh.lodCount = 1;
            }
#endif

#if DEBUG
            if (vertices.IsCreated == false)
            {
                throw new Exception("Cannot create a mesh from a river mesh generation job that has not been executed yet!");
            }
#endif

            int vertexCount = vertices.Length;
            if (vertexCount == 0)
            {
                Debug.LogError("Mesh generation failed! No vertices were provided!");
                return mesh;
            }
            
            mesh.SetVertexBufferParams(vertexCount, VertexAttributes);
            mesh.SetVertexBufferData(vertices.AsArray(), 0, 0, vertexCount, 0);
            
            //Triangles
            var triangleValidation = MeshValidationFlags;
            
#if UNITY_EDITOR
            //Gizmo mesh drawing requires validated indices
            triangleValidation &= MeshUpdateFlags.DontValidateIndices;
#endif
            
            int indexCount = indices.Length;
            mesh.SetIndexBufferParams(indexCount, IndexFormat.UInt16);
            mesh.SetIndexBufferData(indices.AsArray(), 0, 0, indexCount);
            
            mesh.subMeshCount = 1;
            mesh.SetSubMesh(0, new SubMeshDescriptor(0, indexCount));
            
#if UNITY_6000_2_OR_NEWER
            int lodLevels = lodIndexRanges.Length;
            if (lodLevels > 1)
            {
                mesh.lodCount = lodLevels;
                
                for (int lod = 0; lod < lodLevels; lod++)
                {
                    uint2 range = lodIndexRanges[lod];
                    mesh.SetLod(0, lod, new MeshLodRange(range.x, range.y));
                }
                
                float lodSlope = Mathf.Max(0.01f, geometrySettings.lodSelectionSlope);

                //Slope is only really correct when QualitySettings.meshLodThreshold = 1000. So compensate in the mesh curve bias
                float thresholdBias = lodSlope * Mathf.Log(1000f, 2f);
                float lodBias = thresholdBias;
                
                mesh.lodSelectionCurve = new Mesh.LodSelectionCurve(lodSlope, lodBias);
            }
#endif
            //Collider needs to be kept readable, so a MeshCollider can post-process in a build
            //mesh.UploadMeshData(false);
            
            //mesh.RecalculateNormals();
            //mesh.RecalculateTangents();
            
            Bounds bounds = mesh.bounds;
            bounds.SetMinMax(boundsMin, boundsMax);
            mesh.bounds = bounds;
            
            return mesh;
        }
        
        public void Dispose()
        {
            vertices.Dispose();
            indices.Dispose();
#if UNITY_6000_2_OR_NEWER
            lodIndexRanges.Dispose();
#endif
            metaData.Dispose();
            #if VFX_GRAPH
            particles.Dispose();
            #endif
            audioEmitters.Dispose();
        }
    }
}
#endif