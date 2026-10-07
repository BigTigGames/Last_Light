using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using StylizedWater3;

/// <summary>
/// Attach to the Water_Buoyancy_Manager GameObject.
///
/// Scans the scene at runtime for objects tagged "FloatingProp", and optionally
/// walks a Props group Transform, attaching AlignToWater to any qualifying object
/// so it rides the water surface.
///
/// Runtime fixes applied:
///   • Initialisation deferred to Start() so WaterObject.Instances is populated
///     (WaterObject registers itself in OnEnable, which runs before Start).
///   • Any Rigidbody taken over is set isKinematic = true so AlignToWater's
///     MovePosition/Move calls don't fight the physics solver.
///   • A one-frame coroutine retry handles late-enabled WaterObjects (async load,
///     additive scenes).
///   • No #if UNITY_EDITOR guards wrap any runtime logic.
///   • Dynamic null check re-resolves the WaterObject each frame via
///     WaterObject.Find() if the cached reference becomes invalid.
/// </summary>
public class WaterFloatingBodySetup : MonoBehaviour
{
    [Header("Water Source")]
    [Tooltip("The WaterObject on your main lake/river mesh. Auto-resolved at Start if left null.")]
    public WaterObject targetWaterObject;

    [Header("Prop Discovery")]
    [Tooltip("Root of the Props group to scan. Leave null to rely on tag alone.")]
    public Transform propsRoot;

    [Tooltip("Tag on any GameObject that should float. Create it in Project Settings → Tags & Layers.")]
    public string floatingTag = "FloatingProp";

    [Header("Buoyancy Tuning")]
    [Tooltip("Footprint used to sample water height (metres). Larger = smoother tilt.")]
    public Vector2 defaultSurfaceSize = new Vector2(0.8f, 0.8f);

    [Tooltip("Extra vertical offset above the resolved water height.")]
    public float heightOffset = 0f;

    [Range(0f, 1f)]
    [Tooltip("How strongly the object tilts with wave slope. 0 = always upright.")]
    public float rollAmount = 0.05f;

    [Min(0f)]
    [Tooltip("Smoothing on position and rotation changes. Lower = more responsive.")]
    public float smoothing = 0.15f;

    // Tracks every AlignToWater we own so we can reconfigure if settings change.
    private readonly List<AlignToWater> _managed = new List<AlignToWater>();
    private bool _initialised;

    // -------------------------------------------------------------------------
    // Unity lifecycle — use Start, not Awake
    // Reason: WaterObject.OnEnable() (which adds to WaterObject.Instances) runs
    // before Start but AFTER other scripts' Awake calls. Deferring to Start
    // guarantees the Instances list is fully populated when we query it.
    // -------------------------------------------------------------------------
    private void Start()
    {
        ResolveWaterObject();

        if (targetWaterObject == null)
        {
            // WaterObject might be on a renderer that hasn't enabled yet (additive
            // scene, async load). Retry next frame via coroutine.
            StartCoroutine(RetryNextFrame());
            return;
        }

        Initialise();
    }

    private IEnumerator RetryNextFrame()
    {
        // Wait one full frame for all OnEnable calls to complete.
        yield return null;

        ResolveWaterObject();

        if (targetWaterObject == null)
        {
            Debug.LogWarning(
                "[WaterFloatingBodySetup] No WaterObject found after one-frame retry. " +
                "Assign the 'Target Water Object' field manually in the Inspector.", this);
            yield break;
        }

        Initialise();
    }

    private void ResolveWaterObject()
    {
        if (targetWaterObject != null) return;          // already set in Inspector

        if (WaterObject.Instances.Count > 0)
        {
            targetWaterObject = WaterObject.Instances[0];
            Debug.Log($"[WaterFloatingBodySetup] Auto-resolved WaterObject: " +
                      $"{targetWaterObject.name}", this);
        }
    }

    private void Initialise()
    {
        _managed.Clear();

        AttachToTaggedObjects();

        if (propsRoot != null)
            ScanPropsGroup(propsRoot);

        _initialised = true;

        Debug.Log(
            $"[WaterFloatingBodySetup] Runtime init complete — " +
            $"{_managed.Count} floating object(s) registered.", this);
    }

    // -------------------------------------------------------------------------
    // Update — re-validate managed objects every frame (handles scene changes).
    // AlignToWater drives its own FixedUpdate internally; we only need to guard
    // against null references here.
    // -------------------------------------------------------------------------
    private void Update()
    {
        if (!_initialised) return;

        // If the cached WaterObject was destroyed (e.g. level reload), re-resolve.
        if (targetWaterObject == null)
        {
            ResolveWaterObject();
            if (targetWaterObject != null)
                ReconfigureAll();
        }
    }

    // -------------------------------------------------------------------------
    // Tag-based discovery
    // -------------------------------------------------------------------------
    private void AttachToTaggedObjects()
    {
        GameObject[] tagged;
        try
        {
            tagged = GameObject.FindGameObjectsWithTag(floatingTag);
        }
        catch (UnityException)
        {
            Debug.LogWarning(
                $"[WaterFloatingBodySetup] Tag '{floatingTag}' does not exist. " +
                "Add it in Project Settings → Tags & Layers, then re-enter Play Mode.", this);
            return;
        }

        foreach (GameObject go in tagged)
            Attach(go);
    }

    // -------------------------------------------------------------------------
    // Props-group scan
    // Attaches to any object that has a Rigidbody or a recognised floating name.
    // -------------------------------------------------------------------------
    private void ScanPropsGroup(Transform root)
    {
        foreach (Transform child in root)
        {
            bool hasRb       = child.GetComponent<Rigidbody>() != null;
            bool namedMatch  = MatchesFloatingKeyword(child.name);

            if ((hasRb || namedMatch) && child.GetComponent<AlignToWater>() == null)
                Attach(child.gameObject);

            if (child.childCount > 0)
                ScanPropsGroup(child);
        }
    }

    private static readonly string[] FloatingKeywords =
        { "boat", "crate", "barrel", "lantern", "float", "buoy", "raft", "log" };

    private static bool MatchesFloatingKeyword(string name)
    {
        string lower = name.ToLowerInvariant();
        foreach (string kw in FloatingKeywords)
            if (lower.Contains(kw)) return true;
        return false;
    }

    // -------------------------------------------------------------------------
    // Core attach logic
    // -------------------------------------------------------------------------
    private void Attach(GameObject go)
    {
        AlignToWater align = go.GetComponent<AlignToWater>() ?? go.AddComponent<AlignToWater>();

        Configure(align);

        if (!_managed.Contains(align))
            _managed.Add(align);
    }

    private void Configure(AlignToWater align)
    {
        // CPU method replicates wave maths locally — no GPU readback, works on
        // all platforms, no latency.
        align.heightInterface.method      = HeightQuerySystem.Interface.Method.CPU;
        align.heightInterface.waterObject = targetWaterObject;
        align.heightInterface.waterLevel  = targetWaterObject != null
            ? targetWaterObject.transform.position.y
            : 0f;

        align.surfaceSize  = defaultSurfaceSize;
        align.heightOffset = heightOffset;
        align.rollAmount   = rollAmount;
        align.smoothing    = smoothing;

        // Rigidbody handling — critical for Play Mode stability
        Rigidbody rb = align.GetComponent<Rigidbody>();
        if (rb != null)
        {
            // isKinematic MUST be true: AlignToWater drives position via
            // rigidbody.Move() / MovePosition(). If the body is non-kinematic the
            // physics solver fights the explicit position every fixed step →
            // oscillation / freeze. Gravity is irrelevant once kinematic, but
            // disable it too for clarity.
            rb.isKinematic = true;
            rb.useGravity  = false;
            align.rigidbody = rb;
        }
    }

    /// <summary>
    /// Re-applies configuration to all managed AlignToWater instances.
    /// Called automatically when the WaterObject reference is re-resolved at runtime.
    /// </summary>
    private void ReconfigureAll()
    {
        foreach (AlignToWater align in _managed)
        {
            if (align != null)
                Configure(align);
        }
    }

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------

    /// <summary>
    /// Register a dynamically spawned object (e.g. a runtime-instantiated crate)
    /// so it floats on the water surface.
    /// </summary>
    public void RegisterFloatingObject(GameObject go) => Attach(go);

    /// <summary>
    /// Returns a read-only view of all currently managed AlignToWater components.
    /// </summary>
    public IReadOnlyList<AlignToWater> ManagedObjects => _managed;
}
