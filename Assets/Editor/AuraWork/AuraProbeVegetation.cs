using System;
using System.Text;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace AuraWork
{
    public static class AuraProbeVegetation
    {
        public static string Execute()
        {
            var sb = new StringBuilder();
            var roots = SceneManager.GetActiveScene().GetRootGameObjects();

            string[] veg = { "herotree", "foliage", "leaf", "bush", "plant", "flower", "fern",
                             "tree", "grass", "clump", "ivy", "vine", "moss", "log" };

            // group by name prefix, report aggregate bounds and max height
            var agg = new Dictionary<string, Bounds>();
            var cnt = new Dictionary<string, int>();
            var mxY = new Dictionary<string, float>();

            foreach (var r in roots)
            {
                foreach (var t in r.GetComponentsInChildren<Transform>(true))
                {
                    string n = t.name.ToLowerInvariant();
                    bool hit = false;
                    foreach (var k in veg) { if (n.Contains(k)) { hit = true; break; } }
                    if (!hit) continue;

                    var rs = t.GetComponentsInChildren<Renderer>(true);
                    if (rs.Length == 0) continue;
                    Bounds bd = rs[0].bounds;
                    for (int k = 1; k < rs.Length; k++) bd.Encapsulate(rs[k].bounds);

                    // strip a trailing " (n)" instance suffix so instances group together
                    string key = t.name;
                    int par = key.LastIndexOf(" (", StringComparison.Ordinal);
                    if (par > 0 && key.EndsWith(")")) key = key.Substring(0, par);

                    if (!agg.ContainsKey(key)) { agg[key] = bd; cnt[key] = 0; mxY[key] = bd.size.y; }
                    else { var b = agg[key]; b.Encapsulate(bd); agg[key] = b; }
                    if (bd.size.y > mxY[key]) mxY[key] = bd.size.y;
                    cnt[key]++;
                }
            }

            sb.AppendLine("=== VEGETATION GROUPS (sorted by tallness) ===");
            var list = new List<KeyValuePair<string, Bounds>>(agg);
            list.Sort((a, b) => mxY[b.Key].CompareTo(mxY[a.Key]));
            for (int i = 0; i < list.Count && i < 45; i++)
            {
                var k = list[i].Key;
                sb.AppendLine("  " + k.PadRight(46) + " n=" + cnt[k].ToString().PadRight(4) +
                              " maxH=" + mxY[k].ToString("F1").PadRight(6) +
                              " aggCenter=" + agg[k].center.ToString("F0") +
                              " aggSize=" + agg[k].size.ToString("F0"));
            }

            // ---- tallest things in the scene at all (vegetation-free view) ----
            sb.AppendLine("=== TALLEST TRANSFORM GROUPS OVERALL (>8 m) ===");
            var tall = new Dictionary<string, float>();
            var tallPos = new Dictionary<string, Vector3>();
            var tallN = new Dictionary<string, int>();
            foreach (var r in roots)
            {
                foreach (var t in r.GetComponentsInChildren<Transform>(true))
                {
                    var rs = t.GetComponentsInChildren<Renderer>(true);
                    if (rs.Length == 0) continue;
                    Bounds bd = rs[0].bounds;
                    for (int k = 1; k < rs.Length; k++) bd.Encapsulate(rs[k].bounds);
                    if (bd.size.y <= 8f) continue;
                    string key = t.name;
                    int par = key.LastIndexOf(" (", StringComparison.Ordinal);
                    if (par > 0 && key.EndsWith(")")) key = key.Substring(0, par);
                    if (!tall.ContainsKey(key) || bd.size.y > tall[key])
                    {
                        tall[key] = bd.size.y;
                        tallPos[key] = bd.center;
                    }
                    if (!tallN.ContainsKey(key)) tallN[key] = 0;
                    tallN[key]++;
                }
            }
            var tl = new List<KeyValuePair<string, float>>(tall);
            tl.Sort((a, b) => b.Value.CompareTo(a.Value));
            for (int i = 0; i < tl.Count && i < 30; i++)
                sb.AppendLine("  " + tl[i].Key.PadRight(46) + " h=" + tl[i].Value.ToString("F1").PadRight(8) +
                              " n=" + tallN[tl[i].Key].ToString().PadRight(4) + " center=" + tallPos[tl[i].Key].ToString("F0"));

            return sb.ToString();
        }
    }
}
