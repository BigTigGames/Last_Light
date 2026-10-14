using System;
using System.Text;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace AuraWork
{
    public static class AuraReconCanopy
    {
        public static string Execute()
        {
            var sb = new StringBuilder();

            foreach (var container in new[] { "_TRIFORGE_ASSETS", "_POLYART_DREAMSCAPE_EASTLANDS" })
            {
                var go = GameObject.Find(container);
                sb.AppendLine("=== " + container + " ===");
                if (go == null) { sb.AppendLine("  NOT FOUND"); continue; }

                var rends = go.GetComponentsInChildren<MeshRenderer>(true);
                var lodGroups = go.GetComponentsInChildren<LODGroup>(true);
                sb.AppendLine("  MeshRenderers=" + rends.Length + "  LODGroups=" + lodGroups.Length);

                Bounds b = new Bounds();
                bool first = true;
                var prefixes = new Dictionary<string, int>();
                int tall = 0;
                var tallPrefixes = new Dictionary<string, int>();
                foreach (var r in rends)
                {
                    if (first) { b = r.bounds; first = false; } else b.Encapsulate(r.bounds);

                    var n = r.gameObject.name;
                    var parts = n.Split('_');
                    string pre = parts.Length >= 3 ? parts[0] + "_" + parts[1] + "_" + parts[2]
                               : (parts.Length >= 2 ? parts[0] + "_" + parts[1] : parts[0]);
                    if (!prefixes.ContainsKey(pre)) prefixes[pre] = 0;
                    prefixes[pre]++;

                    if (r.bounds.size.y > 4f)
                    {
                        tall++;
                        if (!tallPrefixes.ContainsKey(pre)) tallPrefixes[pre] = 0;
                        tallPrefixes[pre]++;
                    }
                }
                sb.AppendLine("  bounds: center=" + b.center.ToString("F0") + " size=" + b.size.ToString("F0"));
                sb.AppendLine("  renderers taller than 4 m: " + tall);

                var sorted = new List<KeyValuePair<string, int>>(prefixes);
                sorted.Sort((x, y) => y.Value.CompareTo(x.Value));
                sb.AppendLine("  top prefixes:");
                for (int i = 0; i < sorted.Count && i < 18; i++)
                    sb.AppendLine("      " + sorted[i].Key.PadRight(28) + sorted[i].Value);

                var ts = new List<KeyValuePair<string, int>>(tallPrefixes);
                ts.Sort((x, y) => y.Value.CompareTo(x.Value));
                sb.AppendLine("  top TALL prefixes:");
                for (int i = 0; i < ts.Count && i < 18; i++)
                    sb.AppendLine("      " + ts[i].Key.PadRight(28) + ts[i].Value);
            }

            // ---- tree-ish objects anywhere in the scene, by LODGroup ----
            sb.AppendLine("=== SCENE-WIDE LODGROUP-OWNED ROOTS (name contains tree/foliage/leaf) ===");
            var roots = UnityEngine.SceneManagement.SceneManager.GetActiveScene().GetRootGameObjects();
            var hits = new List<string>();
            var pts = new Dictionary<string, List<Vector3>>();
            var counts = new Dictionary<string, int>();
            foreach (var r in roots)
            {
                foreach (var lg in r.GetComponentsInChildren<LODGroup>(true))
                {
                    var n = lg.gameObject.name.ToLowerInvariant();
                    bool isTree = n.Contains("tree") || n.Contains("foliage") || n.Contains("leaf") ||
                                  n.Contains("bush") || n.Contains("pine") || n.Contains("canopy");
                    if (!isTree) continue;
                    string key = lg.gameObject.name.Split(' ')[0];
                    if (!counts.ContainsKey(key)) { counts[key] = 0; pts[key] = new List<Vector3>(); }
                    counts[key]++;
                    pts[key].Add(lg.transform.position);
                    if (hits.Count < 25) hits.Add(lg.transform.position.ToString("F1") + "  " + lg.gameObject.name);
                }
            }
            foreach (var h in hits) sb.AppendLine("   " + h);
            sb.AppendLine("  distinct tree-ish LODGroup name keys: " + counts.Count);
            var ck = new List<KeyValuePair<string, int>>(counts);
            ck.Sort((x, y) => y.Value.CompareTo(x.Value));
            for (int i = 0; i < ck.Count && i < 15; i++)
            {
                var list = pts[ck[i].Key];
                Vector3 sum = Vector3.zero;
                foreach (var v in list) sum += v;
                Vector3 centre = list.Count > 0 ? sum / list.Count : Vector3.zero;
                sb.AppendLine("      " + ck[i].Key.PadRight(40) + ck[i].Value + "   aggCenter=" + centre.ToString("F0") +
                              "   extentX=" + (MaxX(list) - MinX(list)).ToString("F0") +
                              "   extentZ=" + (MaxZ(list) - MinZ(list)).ToString("F0"));
            }

            // ---- river segment objects (for water placement) ----
            sb.AppendLine("=== RIVER SEGMENT OBJECTS ===");
            int rc = 0;
            foreach (var r in roots)
            {
                foreach (var t in r.GetComponentsInChildren<Transform>(true))
                {
                    if (!t.name.StartsWith("River Segment")) continue;
                    var mr = t.GetComponent<MeshRenderer>();
                    sb.AppendLine("   " + t.name + "  pos=" + t.position.ToString("F1") +
                                  "  boundsSize=" + (mr != null ? mr.bounds.size.ToString("F0") : "<no mesh>") +
                                  "  parent=" + (t.parent != null ? t.parent.name : "<none>"));
                    rc++;
                }
            }
            sb.AppendLine("  river segment objects: " + rc);

            // ---- verify the Stylized Water ripple prefab ----
            sb.AppendLine("=== WATER RIPPLE PREFAB CHECK ===");
            string rp = "Assets/Stylized Water 3/Prefabs/Particles/WaterRipples_Stationairy.prefab";
            var rgo = AssetDatabase.LoadAssetAtPath<GameObject>(rp);
            sb.AppendLine("  " + rp + " -> " + (rgo != null ? "OK" : "NULL"));
            if (rgo != null)
            {
                var ps = rgo.GetComponentInChildren<ParticleSystem>(true);
                if (ps == null) sb.AppendLine("    no ParticleSystem");
                else
                {
                    var m = ps.main;
                    sb.AppendLine("    loop=" + m.loop + " playOnAwake=" + m.playOnAwake + " duration=" + m.duration +
                                  " maxParticles=" + m.maxParticles + " space=" + m.simulationSpace);
                    var e = ps.emission;
                    sb.AppendLine("    emitRate=" + e.rateOverTime.constant + " bursts=" + e.burstCount);
                    var rnd = ps.GetComponent<ParticleSystemRenderer>();
                    sb.AppendLine("    renderMode=" + (rnd != null ? rnd.renderMode.ToString() : "?") +
                                  " mat=" + (rnd != null && rnd.sharedMaterial != null ? rnd.sharedMaterial.name : "<null>"));
                }
            }

            return sb.ToString();
        }

        private static float MinX(List<Vector3> l)
        {
            float v = float.MaxValue;
            foreach (var p in l) if (p.x < v) v = p.x;
            return l.Count == 0 ? 0f : v;
        }

        private static float MaxX(List<Vector3> l)
        {
            float v = float.MinValue;
            foreach (var p in l) if (p.x > v) v = p.x;
            return l.Count == 0 ? 0f : v;
        }

        private static float MinZ(List<Vector3> l)
        {
            float v = float.MaxValue;
            foreach (var p in l) if (p.z < v) v = p.z;
            return l.Count == 0 ? 0f : v;
        }

        private static float MaxZ(List<Vector3> l)
        {
            float v = float.MinValue;
            foreach (var p in l) if (p.z > v) v = p.z;
            return l.Count == 0 ? 0f : v;
        }
    }
}
