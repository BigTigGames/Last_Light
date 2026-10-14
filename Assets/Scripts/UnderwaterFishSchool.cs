using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Confines a school of fish to a submerged volume and swims them between random waypoints.
///
/// Placement rules enforced here (not just at authoring time):
///   • No Rigidbody is ever required or added — the transform is driven directly, so the school
///     cannot fight Water_Buoyancy_Manager's AlignToWater / physics loops.
///   • Every position is clamped inside the bounds box AND strictly below the water surface,
///     so no fish can breach the StylizedWater_Desktop plane regardless of the waypoint chosen.
/// </summary>
[DisallowMultipleComponent]
[AddComponentMenu("Aura/Underwater Fish School")]
public class UnderwaterFishSchool : MonoBehaviour
{
    [Header("Swim Volume (world space)")]
    [Tooltip("Centre of the submerged volume the school is confined to.")]
    public Vector3 boundsCenter = new Vector3(612f, 6.9f, 100f);

    [Tooltip("Full size of the submerged volume. Y is further capped by the water surface.")]
    public Vector3 boundsSize = new Vector3(230f, 2.4f, 175f);

    [Header("Surface / Bed Clearance")]
    [Tooltip("World Y of the StylizedWater_Desktop surface plane. Measured: 8.8799.")]
    public float waterSurfaceY = 8.8799f;

    [Tooltip("Minimum gap kept between a fish and the water surface.")]
    public float surfaceClearance = 0.35f;

    [Tooltip("Minimum gap kept between a fish and the terrain bed.")]
    public float bedClearance = 0.6f;

    [Header("Swimming")]
    public float speed = 1.1f;
    public float speedVariance = 0.45f;
    public float turnRate = 2.2f;
    public float verticalFollow = 0.7f;
    public float bobAmplitude = 0.12f;
    public float bobFrequency = 0.9f;

    [Header("Waypoints")]
    public float waypointRadius = 2.5f;
    public int seed = 20261012;

    private struct Fish
    {
        public Transform t;
        public Vector3 target;
        public float speed;
        public float bobPhase;
        public float baseY;
    }

    private readonly List<Fish> _fish = new List<Fish>();
    private System.Random _rng;
    private float _time;

    private void Awake()
    {
        _rng = new System.Random(seed);
        _time = 0f;

        for (int i = 0; i < transform.childCount; i++)
        {
            Transform child = transform.GetChild(i);
            if (child == null) continue;

            var f = new Fish
            {
                t       = child,
                speed   = speed + ((float)_rng.NextDouble() * 2f - 1f) * speedVariance,
                bobPhase = (float)_rng.NextDouble() * Mathf.PI * 2f,
                baseY   = child.position.y
            };

            child.position = ClampToVolume(child.position);
            f.baseY = child.position.y;
            f.target = PickWaypoint();
            _fish.Add(f);
        }
    }

    private void Update()
    {
        float dt = Time.deltaTime;
        if (dt <= 0f) return;
        _time += dt;

        for (int i = 0; i < _fish.Count; i++)
        {
            Fish f = _fish[i];
            if (f.t == null) continue;

            Vector3 pos = f.t.position;
            Vector3 to = f.target - pos;
            to.y = 0f;

            if (to.sqrMagnitude < waypointRadius * waypointRadius)
            {
                f.target = PickWaypoint();
                to = f.target - pos;
                to.y = 0f;
            }

            if (to.sqrMagnitude > 0.0001f)
            {
                Vector3 dir = to.normalized;

                // The carp's mesh bounds are (0.23, 0.31, 0.65) — its long axis is +Z, so
                // LookRotation on the heading orients it nose-first with no correction offset.
                Quaternion want = Quaternion.LookRotation(dir, Vector3.up);
                f.t.rotation = Quaternion.Slerp(f.t.rotation, want, Mathf.Clamp01(turnRate * dt));

                pos += dir * f.speed * dt;
            }

            f.baseY = Mathf.Lerp(f.baseY, f.target.y, Mathf.Clamp01(verticalFollow * dt));
            pos.y = f.baseY + Mathf.Sin(_time * bobFrequency + f.bobPhase) * bobAmplitude;

            f.t.position = ClampToVolume(pos);
            _fish[i] = f;
        }
    }

    /// <summary>
    /// Hard confinement. The Y ceiling is whichever is lower: the box top or the water surface
    /// minus clearance — so a fish is always strictly submerged.
    /// </summary>
    private Vector3 ClampToVolume(Vector3 p)
    {
        Vector3 half = boundsSize * 0.5f;
        Vector3 min = boundsCenter - half;
        Vector3 max = boundsCenter + half;

        float ceiling = Mathf.Min(max.y, waterSurfaceY - surfaceClearance);
        float floor = Mathf.Max(min.y, TerrainBedY(p.x, p.z) + bedClearance);

        p.x = Mathf.Clamp(p.x, min.x, max.x);
        p.z = Mathf.Clamp(p.z, min.z, max.z);

        if (floor > ceiling) floor = ceiling;
        p.y = Mathf.Clamp(p.y, floor, ceiling);
        return p;
    }

    private Vector3 PickWaypoint()
    {
        for (int attempt = 0; attempt < 8; attempt++)
        {
            Vector3 c = boundsCenter + new Vector3(
                ((float)_rng.NextDouble() - 0.5f) * boundsSize.x,
                ((float)_rng.NextDouble() - 0.5f) * boundsSize.y,
                ((float)_rng.NextDouble() - 0.5f) * boundsSize.z);

            c = ClampToVolume(c);
            if (c.y < waterSurfaceY - surfaceClearance) return c;
        }

        return ClampToVolume(boundsCenter);
    }

    private static float TerrainBedY(float x, float z)
    {
        Terrain t = Terrain.activeTerrain;
        return t == null ? float.NegativeInfinity : t.SampleHeight(new Vector3(x, 0f, z)) + t.transform.position.y;
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = new Color(0.1f, 0.8f, 1f, 0.5f);
        Gizmos.DrawWireCube(boundsCenter, boundsSize);

        float ceiling = waterSurfaceY - surfaceClearance;
        Vector3 center = new Vector3(boundsCenter.x, (ceiling + boundsCenter.y - boundsSize.y * 0.5f) * 0.5f, boundsCenter.z);
        float height = Mathf.Max(0.01f, ceiling - (boundsCenter.y - boundsSize.y * 0.5f));
        Gizmos.color = new Color(1f, 0.9f, 0.2f, 0.6f);
        Gizmos.DrawWireCube(center, new Vector3(boundsSize.x, height, boundsSize.z));
    }
}
