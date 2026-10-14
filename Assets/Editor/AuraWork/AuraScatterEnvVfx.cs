using System;
using System.Text;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace AuraWork
{
    public static class AuraScatterEnvVfx
    {
        private const string RootName = "_ENVIRONMENT_VFX_CROWD";
        private const string ManagerName = "_SYSTEM_MANAGERS";
        private const int Seed = 20261014;

        // Real, verified prefab assets in this project.
        private const string PfxLeaves =
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_BlowingLeaves_01.prefab";
        private const string PfxPollen =
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_Dust_01.prefab";
        private const string PfxFieldMotes =
            "Assets/Third_Party_assets/Polyart/PolyartStudio/SharedResources/Effects/P_Dust_Wind.prefab";
        private const string PfxRipple =
            "Assets/Stylized Water 3/Prefabs/Particles/WaterRipples_Stationairy.prefab";
        private const string PfxSplash =
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Forest Environment/Particle Effects/PS_FFE_Watersplash.prefab";

        public static string Execute()
        {
            var sb = new StringBuilder();
            if (Application.isPlaying)
            {
                sb.AppendLine("ABORT: Play mode is active. Refusing to edit/save the scene.");
                return sb.ToString();
            }

            var scene = SceneManager.GetActiveScene();
            var rng = new System.Random(Seed);

            // ---------- 0. idempotency : drop any previous container ----------
            var manager = GameObject.Find(ManagerName);
            if (manager == null) { sb.AppendLine("ABORT: '" + ManagerName + "' not found."); return sb.ToString(); }
            var existing = manager.transform.Find(RootName);
            if (existing != null)
            {
                UnityEngine.Object.DestroyImmediate(existing.gameObject);
                sb.AppendLine("Removed pre-existing " + ManagerName + "/" + RootName);
            }

            var root = new GameObject(RootName);
            root.transform.SetParent(manager.transform, false);
            root.transform.localPosition = Vector3.zero;

            var gLeaves = MakeGroup(root.transform, "Forest_GoldenLeaves");
            var gPollen = MakeGroup(root.transform, "Forest_PollenMotes");
            var gField = MakeGroup(root.transform, "Fields_WindDust");
            var gRipple = MakeGroup(root.transform, "Water_Ripples");
            var gSplash = MakeGroup(root.transform, "Water_ShoreSplash");

            // ---------- 1. gather zone sources from the scene ----------
            var roots = scene.GetRootGameObjects();

            var treePts = new List<Vector3>();      // HeroTree / foliage clumps -> canopies
            var pathPts = new List<Vector3>();      // road + paths -> open field / roadway
            var waterPts = new List<Vector3>();     // river segments + lilies -> water contact
            var waterY = new List<float>();
            var seen = new Dictionary<string, bool>();

            foreach (var r in roots)
            {
                foreach (var t in r.GetComponentsInChildren<Transform>(true))
                {
                    string n = t.name.ToLowerInvariant();

                    if (n.Contains("circleplant") || n.Contains("foliageclump") || n.Contains("ivy") || n == "trees")
                    {
                        // Real foliage in this scene. Skip _LODn children so each instance counts once.
                        if (n.Contains("_lod")) continue;
                        var mr = t.GetComponent<MeshRenderer>();
                        if (mr == null) continue;
                        string key = Mathf.RoundToInt(mr.bounds.center.x / 4f) + ":" + Mathf.RoundToInt(mr.bounds.center.z / 4f);
                        if (seen.ContainsKey(key)) continue;
                        seen[key] = true;
                        treePts.Add(mr.bounds.center);
                    }
                    else if (n.Contains("road") || n.Contains("woodenpath") || n.StartsWith("path"))
                    {
                        var mr = t.GetComponent<MeshRenderer>();
                        if (mr != null) pathPts.Add(mr.bounds.center);
                    }
                    else if (n.StartsWith("river segment") || n.Contains("waterlily"))
                    {
                        var mr = t.GetComponent<MeshRenderer>();
                        if (mr != null && mr.bounds.size.x < 120f)
                        {
                            waterPts.Add(mr.bounds.center);
                            waterY.Add(mr.bounds.center.y);
                        }
                    }
                }
            }
            sb.AppendLine("zone sources: trees=" + treePts.Count + " paths=" + pathPts.Count + " water=" + waterPts.Count);

            // ---------- 2. FOREST : under canopies / foliage ----------
            int nLeaves = 0, nPollen = 0;
            int vegWant = Mathf.Min(30, treePts.Count);
            for (int i = 0; i < vegWant; i++)
            {
                var tree = treePts[(i * 7919) % treePts.Count];   // deterministic stride, spreads across the whole set
                float y = GroundBelow(tree.x, tree.z, tree.y);
                nLeaves += Place(PfxLeaves, gLeaves, tree.x + J(rng, 4.5f), y + 4.5f, tree.z + J(rng, 4.5f), 120, 1f, sb);
                nPollen += Place(PfxPollen, gPollen, tree.x + J(rng, 5.5f), y + 3.2f, tree.z + J(rng, 5.5f), 150, 6f, sb);
            }

            // ---------- 3. OPEN FIELDS / ROADWAY : wind + dust motes ----------
            int nField = 0;
            int want = Mathf.Min(14, Mathf.Max(6, pathPts.Count));
            for (int i = 0; i < want && pathPts.Count > 0; i++)
            {
                var p = pathPts[(i * 7919) % pathPts.Count];      // deterministic stride over the path set
                float y = GroundBelow(p.x, p.z, p.y);
                nField += Place(PfxFieldMotes, gField, p.x + J(rng, 6f), y + 2.0f, p.z + J(rng, 6f), 150, 8f, sb);
            }

            // ---------- 4. WATER & SHORELINE : ripples + soft splash ----------
            int nRipple = 0, nSplash = 0;
            int wWant = Mathf.Min(20, Mathf.Max(8, waterPts.Count));
            for (int i = 0; i < wWant && waterPts.Count > 0; i++)
            {
                var p = waterPts[(i * 6151) % waterPts.Count];
                float wy = waterY[(i * 6151) % waterPts.Count] + 0.05f;
                float ox = J(rng, 7f), oz = J(rng, 7f);
                nRipple += Place(PfxRipple, gRipple, p.x + ox, wy, p.z + oz, 60, 2f, sb);
                if (i % 2 == 0)
                    nSplash += Place(PfxSplash, gSplash, p.x - ox, wy + 0.25f, p.z - oz, 80, 6f, sb);
            }

            // ---------- 5. report ----------
            sb.AppendLine("placed: leaves=" + nLeaves + " pollen=" + nPollen + " fieldMotes=" + nField +
                          " ripples=" + nRipple + " splashes=" + nSplash);
            sb.AppendLine("total new ParticleSystems = " + (nLeaves + nPollen + nField + nRipple + nSplash));

            var childCount = root.GetComponentsInChildren<ParticleSystem>(true).Length;
            sb.AppendLine("verified children with ParticleSystem = " + childCount);

            int shadowOn = 0;
            foreach (var r in root.GetComponentsInChildren<ParticleSystemRenderer>(true))
                if (r.shadowCastingMode != ShadowCastingMode.Off) shadowOn++;
            sb.AppendLine("particle renderers still casting shadows = " + shadowOn);

            // ---------- 6. save ----------
            EditorSceneManager.MarkSceneDirty(scene);
            bool ok = EditorSceneManager.SaveScene(scene);
            sb.AppendLine("scene saved = " + ok);
            return sb.ToString();
        }

        // ---------------- helpers ----------------

        private static GameObject MakeGroup(Transform parent, string name)
        {
            var g = new GameObject(name);
            g.transform.SetParent(parent, false);
            return g;
        }

        private static float J(System.Random rng, float amp)
        {
            return (float)((rng.NextDouble() * 2.0 - 1.0) * amp);
        }

        private static float GroundBelow(float x, float z, float fallback)
        {
            var hits = Physics.RaycastAll(new Vector3(x, 350f, z), Vector3.down, 700f, ~0, QueryTriggerInteraction.Ignore);
            if (hits == null || hits.Length == 0) return fallback;
            float best = float.MaxValue;
            bool foundTerrain = false;
            foreach (var h in hits)
            {
                if (h.collider != null && h.collider.name.ToLowerInvariant().Contains("terrain"))
                {
                    if (!foundTerrain || h.point.y > best) { best = h.point.y; foundTerrain = true; }
                }
            }
            if (foundTerrain) return best;
            // no terrain along this ray -> take the lowest solid hit so we never land on a roof
            foreach (var h in hits) if (h.point.y < best) best = h.point.y;
            return best == float.MaxValue ? fallback : best;
        }

        private static int Place(string prefabPath, GameObject parent, float x, float y, float z,
                                 int maxParticles, float emitRate, StringBuilder sb)
        {
            var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
            if (prefab == null) { sb.AppendLine("MISSING PREFAB: " + prefabPath); return 0; }

            var inst = PrefabUtility.InstantiatePrefab(prefab, parent.transform) as GameObject;
            if (inst == null) { sb.AppendLine("instantiate failed: " + prefabPath); return 0; }

            inst.transform.position = new Vector3(x, y, z);
            inst.transform.rotation = Quaternion.Euler(0f, (float)(x + z) % 360f, 0f);
            inst.isStatic = false;

            var ps = inst.GetComponentInChildren<ParticleSystem>(true);
            if (ps != null)
            {
                var main = ps.main;
                main.maxParticles = maxParticles;
                main.playOnAwake = true;
                var em = ps.emission;
                em.rateOverTime = emitRate;
                em.enabled = true;
            }

            // keep the new emitters out of the shadow / GI budget
            foreach (var r in inst.GetComponentsInChildren<ParticleSystemRenderer>(true))
            {
                r.shadowCastingMode = ShadowCastingMode.Off;
                r.receiveShadows = false;
                r.allowOcclusionWhenDynamic = false;
            }
            foreach (var r in inst.GetComponentsInChildren<Renderer>(true))
                r.lightProbeUsage = LightProbeUsage.Off;

            return 1;
        }
    }
}
