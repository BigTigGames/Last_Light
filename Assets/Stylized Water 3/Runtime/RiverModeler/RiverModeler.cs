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
using Unity.Collections;
using UnityEngine;
using Random = UnityEngine.Random;
using Unity.Jobs;
using UnityEngine.Events;
using UnityEngine.Profiling;
#if SPLINES
using Unity.Mathematics;
using UnityEngine.Rendering;
using UnityEngine.Splines;
#endif
#if VFX_GRAPH
using UnityEngine.VFX;
#endif
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace StylizedWater3.RiverModeler
{
    [AddComponentMenu("Stylized Water 3/River Modeler")]
    [ExecuteInEditMode]
    [SelectionBase]
    public partial class RiverModeler : MonoBehaviour
    {
        public Material material;
#if VFX_GRAPH
        public VisualEffectAsset foamVFX;
#endif
        
        public Settings settings = new Settings();

        public List<SplineRiver> rivers = new List<SplineRiver>();

        [Tooltip("Regenerates the river(s) on Start(). This is required if the component is part of a prefab.")]
        public bool rebuildOnStart;

        public const string SCALE_DATA_KEY = "RIVER_SCALE";
        //Splines shorter than this are considered invalid
        private const float MIN_SPLINE_LENGTH = 0.01f;

        internal readonly System.Diagnostics.Stopwatch stopWatch = new System.Diagnostics.Stopwatch();
        public float LastProcessingTime => stopWatch.IsRunning ? 0 : (float)stopWatch.Elapsed.TotalMilliseconds;
        
#pragma warning disable CS0067
        public delegate void OnRebuildRiver(RiverModeler instance, ChangeFlags changeFlags);
        public static event OnRebuildRiver onPreRebuildRiver;
        public static event OnRebuildRiver onPostRebuildRiver;
        
        /// <summary>
        /// UnityEvent for a GameObject's function to be executed when river is rebuild. This is exposed in the inspector.
        /// </summary>
        [Serializable]
        public class RebuildEvent : UnityEvent<ChangeFlags> { }
        /// <summary>
        /// UnityEvent, fires whenever spline is rebuild (eg. editing nodes)
        /// </summary>
        public RebuildEvent onPreRebuild;
        public RebuildEvent onPostRebuild;
#pragma warning restore CS0067

        /// <summary>
        /// Flags used to indicate which aspects of a river is being modified
        /// </summary>
        [Flags]
        public enum ChangeFlags
        {
            None = 0,
            Spline = 1,
            Geometry = 2,
            Scale = 4,
            Foam = 8,
            Transparency = 16,
            Audio = 32,
            MicroVerse = 64,
            All = Spline | Geometry | Scale | Foam | Transparency | Audio | MicroVerse
        }
        
        public static bool HasChangeFlag(ChangeFlags flags, ChangeFlags type)
        {
            return (flags & type) == type;
        }
        
#if SPLINES
        public void Reset()
        {
            if(!SplineContainer) SplineContainer = GetComponentInParent<SplineContainer>();

            #if UNITY_EDITOR
            settings.audio.profile = RiverAudioProfile.LoadDefaultInEditor();
            #endif
            
#if UNITY_EDITOR && VFX_GRAPH
            string path = UnityEditor.AssetDatabase.GUIDToAssetPath("f91270c6f4288ea4f98d1de4a62067fa");
            foamVFX = UnityEditor.AssetDatabase.LoadAssetAtPath<UnityEngine.VFX.VisualEffectAsset>(path);
#endif
        }

        private void Start()
        {
            if(rebuildOnStart) Rebuild();
        }

        private void OnEnable()
        {
            SubscribeSplineCallbacks();
        }

        private void OnDisable()
        {
            UnsubscribeSplineCallbacks();
        }

        public void Rebuild(ChangeFlags changeFlags = ChangeFlags.All, int splineIndex = -1)
        {
            #if SPLINES
            if (!SplineContainer || !material) return;
            
            stopWatch.Restart();
            
            int splineCount = SplineContainer.Splines.Count;
            
            if (splineIndex >= 0)
            {
                RebuildSpline(changeFlags, splineIndex);
            }
            else
            {
                for (int i = 0; i < splineCount; i++)
                {
                    RebuildSpline(changeFlags, i);
                }
            }
            
            stopWatch.Stop();
            #endif
        }

        RiverGenerationJob[] meshJobs = Array.Empty<RiverGenerationJob>();
        
        private void RebuildSpline(ChangeFlags changeFlags, int splineIndex)
        {
            Spline sourceSpline = SplineContainer.Splines[splineIndex];
            NativeSpline spline = new NativeSpline(sourceSpline, SplineContainer.transform.localToWorldMatrix, Allocator.Persistent);
            float splineLength = spline.GetLength();
            
            //Invalid spline
            if (splineLength < MIN_SPLINE_LENGTH || spline.Count < 2) return;
            
#if DEBUG
            //If knots have a NaN rotation, the spline length will be invalid as well
            if (float.IsNaN(splineLength))
            {
                Debug.LogError(
                    $"[River Modeler] Spline #{splineIndex} in {SplineContainer.name} length is NaN. Cannot generate river. This safeguard is not available in release builds and will lead to memory leaks, " +
                    $"ensure you provide only valid splines.", SplineContainer);
            }
#endif
                        
            onPreRebuildRiver?.Invoke(this, changeFlags);
            onPreRebuild?.Invoke(changeFlags);
            
            //Length of a single triangle strip along the spline
            float stripLength = Mathf.Clamp(settings.geometry.minEdgeDistance, 0.1f, settings.output.maxSegmentLength);
            int totalStrips = (int)Mathf.Round(splineLength / stripLength);
            float totalMeshLength = totalStrips * stripLength;
            
            float m_maxSegmentLength = Mathf.Max(settings.output.maxSegmentLength, stripLength);
            int segmentCount = Mathf.CeilToInt(totalMeshLength / m_maxSegmentLength);
            
            //Minimum of 2 segments, to ensure there's always a start/end segment
            segmentCount = Mathf.Max(2, segmentCount);
            
            Array.Resize(ref meshJobs, segmentCount);
            for (int i = 0; i < segmentCount; i++)
            {
                meshJobs[i] = new RiverGenerationJob();
            }

            if (rivers.Count <= splineIndex)
            {
                SplineRiver newRiver = SplineRiver.Create(this);
                rivers.Add(newRiver);
            }
            SplineRiver river = rivers[splineIndex];

            if (river == null) //Possible if an undo on a spline creation was performed
            {
                river = SplineRiver.Create(this);
                rivers[splineIndex] = river;
            }
            river.Owner = this;
            river.SetProperties(material, splineIndex);
            
            #if DEBUG
            if(!Profiler.enabled) river.name = $"Spline #{splineIndex} River";
            #endif
            
            river.PrepareContainers(segmentCount);
            
            Structs.ConnectionInfo startConnection = new Structs.ConnectionInfo();
            Structs.ConnectionInfo endConnection = new Structs.ConnectionInfo();
            
            KnotLinkCollection links = SplineContainer.KnotLinkCollection;
            
            //Container has connected splines, set up connection information for alpha blending
            if (links.Count > 0)
            {
                Profiler.BeginSample($"River Modeler: Setup branching data");
                
                SplineKnotIndex startKnot = new SplineKnotIndex(splineIndex, 0);
                if(links.TryGetKnotLinks(startKnot, out var startLink))
                {
                    SetupConnection(SplineContainer, sourceSpline, splineIndex, ref startConnection, startKnot, startLink, settings.geometry.baseWidth);
                }

                SplineKnotIndex endKnot = new SplineKnotIndex(splineIndex, spline.Count -1);
                if (links.TryGetKnotLinks(endKnot, out var endLink))
                {
                    SetupConnection(SplineContainer, sourceSpline, splineIndex, ref endConnection, endKnot, endLink, settings.geometry.baseWidth);
                }
                
                Profiler.EndSample();
            }

            Profiler.BeginSample($"River Modeler: River Generation");
            
            SplineData<float4> scaleData = GetScaleData(splineIndex);
            RiverData<float4> nativeScaleData = new RiverData<float4>();
            nativeScaleData.Create(spline, scaleData, RiverData<float4>.LerpFloat4Interpolator, Allocator.TempJob);
            
            //Values are in meters
            Vector2 trimRange = new Vector2(0, 0);
            
            NativeArray<JobHandle> jobHandles = new NativeArray<JobHandle>(segmentCount, Allocator.Temp);

            settings.geometry.lodLevels = Mathf.Clamp(settings.geometry.lodLevels, 1, 16);
            
            //Calculate spline range based on accumulated tile count
            int tilesBeforeThisSegment = 0;
            for (int i = 0; i < segmentCount; i++)
            {
                RiverSegment segment = river.Segments[i];
                
                //Crucial, reset the transform position, as it will be shifted to center the pivot point.
                //That translation would end up compounding
                segment.transform.localPosition = Vector3.zero;
                
#if DEBUG
                if(!Profiler.enabled) segment.gameObject.name = $"River Segment #{i}";
#endif
                
                //Calculate how many tiles this segment should contain
                int tilesPerSegment = Mathf.FloorToInt((float)totalStrips / segmentCount);

                //Distribute remainder tiles across segments
                if (i < totalStrips % segmentCount)
                {
                    tilesPerSegment += 1;
                }
                
                //The actual length this segment occupies
                var segmentLength = tilesPerSegment * stripLength;

                float startLength = tilesBeforeThisSegment * stripLength;
                float endLength = startLength + segmentLength;

                var curveRange = new Vector2(
                    trimRange.x + startLength,
                    trimRange.x + endLength);

                tilesBeforeThisSegment += tilesPerSegment;
                
                segment.River = river;
                segment.CurveRange = curveRange;
 
                //Debug.Log($"Segment {i} covers {curveRange} of curve");

                //if (tilesPerSegment > 0)
                {
                    meshJobs[i].Setup(spline, startConnection, endConnection, river.Segments[i].transform.worldToLocalMatrix, curveRange, settings, nativeScaleData);

                    jobHandles[i] = meshJobs[i].Schedule();
                }
            }
            
            JobHandle.CompleteAll(jobHandles);
            jobHandles.Dispose();
            
            Profiler.EndSample();
            
            Profiler.BeginSample($"River Modeler: Mesh+VFX Generation Construction");
            
            #if UNITY_EDITOR
            StaticEditorFlags staticEditorFlags = GameObjectUtility.GetStaticEditorFlags(this.gameObject);
            bool isStatic = this.gameObject.isStatic;
            #endif
            
            for (int i = 0; i < segmentCount; i++)
            {
                RiverSegment segment = river.Segments[i];
                
#if UNITY_EDITOR
                //Copy static flags for OC/GI
                if(isStatic && staticEditorFlags != 0) GameObjectUtility.SetStaticEditorFlags(segment.gameObject, staticEditorFlags);
#endif
                
                meshJobs[i].CreateMesh(ref segment.mesh);;
                segment.SetMaterial(material);

                segment.transform.localPosition = meshJobs[i].pivotOffset;
                
#if DEBUG
                if(!Profiler.enabled) segment.mesh.name = $"{this.name} River Segment #{i}";
#endif
                
                if (settings.audio.enable)
                {
                    segment.SetAudioEmitters(settings.audio.profile, meshJobs[i].audioEmitters);
                }
                else
                {
                    segment.ClearAudioEmitters();
                }
                
                segment.UpdateBounds();
                
                segment.UpdateTrigger(settings.output.boxTriggers);
                segment.UpdateCollider(settings.output.collider);
                
#if VFX_GRAPH
                if (HasChangeFlag(changeFlags, ChangeFlags.Geometry) || HasChangeFlag(changeFlags, ChangeFlags.Foam) ||
                    HasChangeFlag(changeFlags, ChangeFlags.Spline) || HasChangeFlag(changeFlags, ChangeFlags.Scale))
                {
                    int particleCount = meshJobs[i].particles.Length;
                    if (particleCount > 0 && foamVFX)
                    {
                        if (!segment.foamVFX)
                        {
                            segment.foamVFX = segment.gameObject.AddComponent<VisualEffect>();
                        }

                        VFXRenderer m_renderer = segment.foamVFX.GetComponent<VFXRenderer>();
                        m_renderer.sortingOrder = (material.renderQueue - 3000) + 2 + river.SplineIndex;
                        //m_renderer.rendererPriority = 1;

                        segment.foamVFX.visualEffectAsset = foamVFX;

                        segment.CreateVFXData(meshJobs[i].particles);
                    }
                    else
                    {
                        if (segment.foamVFX) CoreUtils.Destroy(segment.foamVFX);
                        segment.ClearParticles();
                    }
                }
#endif
                
                //Mesh has been recreated, safe to dispose of related arrays
                meshJobs[i].Dispose();
            }
            
            nativeScaleData.Dispose();
            spline.Dispose();
            
            onPostRebuildRiver?.Invoke(this, changeFlags);
            onPostRebuild?.Invoke(changeFlags);
            
            Profiler.EndSample();

            if (HasChangeFlag(changeFlags, ChangeFlags.MicroVerse) || HasChangeFlag(changeFlags, ChangeFlags.Scale))
            {
                UpdateMicroVerseSplines();
            }
        }
        
        private static bool TryGetConnectedKnot(SplineKnotIndex targetKnot, IReadOnlyList<SplineKnotIndex> links, out SplineKnotIndex connectedKnot)
        {
            connectedKnot = default;

            for (int i = 0; i < links.Count; i++)
            {
                SplineKnotIndex candidate = links[i];

                bool isTargetKnot = candidate.Spline == targetKnot.Spline && candidate.Knot == targetKnot.Knot;
                
                if (isTargetKnot)
                {
                    continue;
                }
                
                if (candidate.Spline == targetKnot.Spline)
                {
                    continue;
                }
                
                connectedKnot = candidate;
                return true;
            }

            return false;
        }

        public static void SetupConnection(SplineContainer splineContainer, ISpline spline, int splineIndex, ref Structs.ConnectionInfo connection, SplineKnotIndex targetKnot, IReadOnlyList<SplineKnotIndex> links, float width)
        {
            if (!TryGetConnectedKnot(targetKnot, links, out SplineKnotIndex connectedKnot))
            {
                connection.isValid = false;
                return;
            }
            
            int connectedSplineIndex = connectedKnot.Spline;
            int knotIndex = connectedKnot.Knot;
            
            Spline connectedSpline = splineContainer.Splines[connectedSplineIndex];
            float t = connectedSpline.ConvertIndexUnit(knotIndex, PathIndexUnit.Knot, PathIndexUnit.Normalized);

            connection.isValid = true;
            connection.t = t;
            
            //Sample the scale at the connection point
            connectedSpline.TryGetFloat4Data(SCALE_DATA_KEY, out var scaleData);
            float4 scale = scaleData.Evaluate(connectedSpline, t * connectedSpline.GetLength(), new UnityEngine.Splines.Interpolators.LerpFloat4());
            connection.radius = width * scale.x;
            
            //Debug.Log($"Spline #{splineIndex}, knot #{targetKnot.Knot} ({(targetKnot.Knot == 0 ?"START" : "END")}) is connected to: Spline #{connectedSplineIndex}, knot #{knotIndex}, t = {t}, Scale={scale.x}");

            //Now sample this spline at 1 unit along the spline, to check which direction it is traveling
            float startOffset = connection.radius * 0.1f;
            float splineStartDirectionPos = targetKnot.Knot == 0 ? startOffset : spline.GetLength() - startOffset;
            splineStartDirectionPos = spline.ConvertIndexUnit(splineStartDirectionPos, PathIndexUnit.Distance, PathIndexUnit.Normalized);
            
            //Forward directions
            float3 connectionForward = math.normalize(connectedSpline.EvaluateTangent(t));
            float3 forward = math.normalize(spline.EvaluateTangent(splineStartDirectionPos));
                
            if(targetKnot.Knot != 0) forward = -forward;
            
            //Spline postions
            float3 connectionPosition = splineContainer.transform.TransformPoint(connectedSpline.EvaluatePosition(t));
            float3 startPosition = splineContainer.transform.TransformPoint(spline.EvaluatePosition(splineStartDirectionPos));
            
            float3 connectionUp = math.normalize(connectedSpline.EvaluateUpVector(t));
            float3 right = math.normalize(math.cross(connectionForward, connectionUp));
            
            right = math.lerp(right, math.normalize(startPosition - connectionPosition), 0.5f);
                
            //If the forward direction is on the left of the connection forward, flip
            float side = math.cross(connectionForward, forward).y;

            if (side > 0f)
            {
                right = -right;
            }
                
            connection.normal = right;
            connection.position = connectionPosition + connection.normal * connection.radius * 0.4f;
        }
#else
        public void Rebuild(ChangeFlags changeFlags = ChangeFlags.All, int splineIndex = -1) { }
#endif

        partial void UpdateMicroVerseSplines();
        
        public bool IsAllowedToRebuild(bool suppressError = true)
        {
#if UNITY_EDITOR
            //Prefab selected in the Project window, with a River Modeler component on its root
            bool inspectingPrefab = PrefabUtility.IsPartOfPrefabAsset(this.gameObject) && this.gameObject.scene.name != string.Empty;
            
            if (inspectingPrefab && !suppressError)
            {
                Debug.LogError("[River Modeler] Unable to rebuild, since the instance is a prefab in the project, not a scene instance. Unity disallows modifying prefab files directly.", this);
                return false;
            }
            
            return inspectingPrefab == false;
#else
            return true;
#endif
        }
    }
}