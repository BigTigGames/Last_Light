using System;
using System.Text;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace AuraWork
{
    public static class AuraReconZones
    {
        public static string Execute()
        {
            var sb = new StringBuilder();

            // ---------- A. VFX-ish prefab assets ----------
            sb.AppendLine("=== A. VFX-ISH PREFAB ASSETS ===");
            var guids = AssetDatabase.FindAssets("t:Prefab", new[] { "Assets" });
            string[] keys = { "leaf", "leaves", "pollen", "dust", "mote", "ripple", "splash",
                              "petal", "firefl", "butterfl", "windtrail", "mist", "smoke", "vfx",
                              "particle", "spark", "leafs" };
            var hits = new List<string>();
            foreach (var g in guids)
            {
                var p = AssetDatabase.GUIDToAssetPath(g);
                var lower = p.ToLowerInvariant();
                foreach (var k in keys) { if (lower.Contains(k)) { hits.Add(p); break; } }
            }
            hits.Sort(StringComparer.OrdinalIgnoreCase);
            sb.AppendLine("name-matched: " + hits.Count + " of " + guids.Length + " prefabs");
            for (int i = 0; i < hits.Count && i < 90; i++) sb.AppendLine("   " + hits[i]);

            // ---------- B. Which of those actually carry a ParticleSystem ----------
            sb.AppendLine("=== B. OF THOSE, PREFABS CONTAINING A ParticleSystem ===");
            var psList = new List<string>();
            foreach (var p in hits)
            {
                var go = AssetDatabase.LoadAssetAtPath<GameObject>(p);
                if (go == null) continue;
                if (go.GetComponentInChildren<ParticleSystem>(true) != null) psList.Add(p);
            }
            sb.AppendLine("with ParticleSystem: " + psList.Count);
            for (int i = 0; i < psList.Count && i < 90; i++) sb.AppendLine("   " + psList[i]);

            // ---------- E. Scene zone census ----------
            sb.AppendLine("=== E. SCENE ZONE CENSUS ===");
            var roots = UnityEngine.SceneManagement.SceneManager.GetActiveScene().GetRootGameObjects();
            string[] zoneKeys = { "tree", "bush", "grass", "foliage", "fern", "plant", "flower",
                                  "water", "lake", "river", "road", "path", "bridge", "shore", "pond" };
            var counts = new Dictionary<string, int>();
            var bnds = new Dictionary<string, Bounds>();
            foreach (var k in zoneKeys) counts[k] = 0;
            int totalRend = 0;
            foreach (var r in roots)
            {
                foreach (var mr in r.GetComponentsInChildren<MeshRenderer>(true))
                {
                    totalRend++;
                    var n = mr.gameObject.name.ToLowerInvariant();
                    foreach (var k in zoneKeys)
                    {
                        if (!n.Contains(k)) continue;
                        counts[k]++;
                        if (!bnds.ContainsKey(k)) bnds[k] = mr.bounds;
                        else { var bb = bnds[k]; bb.Encapsulate(mr.bounds); bnds[k] = bb; }
                    }
                }
            }
            sb.AppendLine("MeshRenderers: " + totalRend);
            foreach (var k in zoneKeys)
            {
                string s = bnds.ContainsKey(k)
                    ? string.Format("center={0} size={1}", bnds[k].center.ToString("F0"), bnds[k].size.ToString("F0"))
                    : "<none>";
                sb.AppendLine("  " + k.PadRight(8) + " n=" + counts[k].ToString().PadRight(6) + s);
            }

            // ---------- F. Foliage occupancy grid, 50 m cells ----------
            sb.AppendLine("=== F. FOLIAGE OCCUPANCY (50 m cells, top 40) ===");
            var grid = new Dictionary<string, int>();
            string[] foliageKeys = { "tree", "bush", "grass", "fern", "plant", "foliage" };
            var cellBounds = new Dictionary<string, Bounds>();
            foreach (var r in roots)
            {
                foreach (var mr in r.GetComponentsInChildren<MeshRenderer>(true))
                {
                    var n = mr.gameObject.name.ToLowerInvariant();
                    bool isFol = false;
                    foreach (var k in foliageKeys) { if (n.Contains(k)) { isFol = true; break; } }
                    if (!isFol) continue;
                    var c = mr.bounds.center;
                    string key = Mathf.FloorToInt(c.x / 50f) + "," + Mathf.FloorToInt(c.z / 50f);
                    if (!grid.ContainsKey(key)) grid[key] = 0;
                    grid[key]++;
                    if (!cellBounds.ContainsKey(key)) cellBounds[key] = mr.bounds;
                    else { var bb = cellBounds[key]; bb.Encapsulate(mr.bounds); cellBounds[key] = bb; }
                }
            }
            var cells = new List<KeyValuePair<string, int>>(grid);
            cells.Sort((a, b) => b.Value.CompareTo(a.Value));
            sb.AppendLine("populated cells: " + cells.Count);
            for (int i = 0; i < cells.Count && i < 40; i++)
            {
                var cb = cellBounds[cells[i].Key].center;
                sb.AppendLine("  cell " + cells[i].Key.PadRight(10) + " n=" + cells[i].Value.ToString().PadRight(5) +
                              " worldCenter=" + cb.ToString("F0"));
            }

            // ---------- G. Water / shoreline objects ----------
            sb.AppendLine("=== G. WATER-NAMED OBJECTS (top 40) ===");
            int wc = 0;
            foreach (var r in roots)
            {
                foreach (var mr in r.GetComponentsInChildren<MeshRenderer>(true))
                {
                    var n = mr.gameObject.name.ToLowerInvariant();
                    if (!(n.Contains("water") || n.Contains("lake") || n.Contains("river") || n.Contains("pond"))) continue;
                    if (wc < 40)
                        sb.AppendLine("  " + mr.transform.position.ToString("F1").PadRight(28) +
                                      " size=" + mr.bounds.size.ToString("F0").PadRight(20) + mr.gameObject.name);
                    wc++;
                }
            }
            sb.AppendLine("total water-named MeshRenderers: " + wc);

            return sb.ToString();
        }
    }
}
