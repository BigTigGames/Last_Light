using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class AuraProbeVillagerGround
{
    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();
        Scene scene = SceneManager.GetActiveScene();
        GameObject[] roots = scene.GetRootGameObjects();

        Stack<Transform> stack = new Stack<Transform>();
        for (int i = 0; i < roots.Length; i++) stack.Push(roots[i].transform);

        int n = 0;
        while (stack.Count > 0)
        {
            Transform t = stack.Pop();
            for (int i = 0; i < t.childCount; i++) stack.Push(t.GetChild(i));

            Component patrol = null;
            Component[] cs = t.GetComponents<Component>();
            for (int c = 0; c < cs.Length; c++)
            {
                if (cs[c] == null) continue;
                if (cs[c].GetType().Name == "TownVillagerPatrol") { patrol = cs[c]; break; }
            }
            if (patrol == null) continue;
            if (!t.gameObject.activeInHierarchy) continue;

            n++;
            Vector3 p = t.position;

            // --- highest collider surface directly under the agent, excluding the agent's own colliders ---
            float best = float.NegativeInfinity;
            string bestName = "none";
            RaycastHit[] hits = Physics.RaycastAll(new Vector3(p.x, p.y + 4f, p.z), Vector3.down, 15f,
                                                   ~0, QueryTriggerInteraction.Ignore);
            for (int h = 0; h < hits.Length; h++)
            {
                if (hits[h].collider == null) continue;
                if (hits[h].collider.transform.IsChildOf(t)) continue;
                if (hits[h].point.y > best) { best = hits[h].point.y; bestName = hits[h].collider.name; }
            }
            bool hasGround = !float.IsNegativeInfinity(best);

            // --- lowest currently-rendered vertex bounds of the character ---
            float lowest = float.PositiveInfinity;
            Renderer[] rs = t.GetComponentsInChildren<Renderer>(true);
            for (int r = 0; r < rs.Length; r++)
            {
                if (rs[r] == null || !rs[r].enabled) continue;
                if (rs[r].bounds.min.y < lowest) lowest = rs[r].bounds.min.y;
            }
            bool hasLow = !float.IsPositiveInfinity(lowest);

            sb.AppendLine("[" + n + "] " + t.name);
            sb.AppendLine("      pivot.y         = " + p.y.ToString("F5"));
            sb.AppendLine("      groundTop.y     = " + (hasGround ? best.ToString("F5") + "   via '" + bestName + "'" : "NO COLLIDER HIT"));
            sb.AppendLine("      pivot - ground  = " + (hasGround ? (p.y - best).ToString("F5") : "n/a"));
            sb.AppendLine("      lowestRenderer  = " + (hasLow ? lowest.ToString("F5") : "none"));
            sb.AppendLine("      feet - ground   = " + ((hasGround && hasLow) ? (lowest - best).ToString("F5") : "n/a"));
        }

        sb.AppendLine("ACTIVE villagers measured = " + n);
        return sb.ToString();
    }
}
