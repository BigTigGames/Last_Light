using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using BigTigGames;

public static class AuraVillagerGroundGap
{
    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();
        Scene sc = SceneManager.GetActiveScene();
        GameObject[] roots = sc.GetRootGameObjects();

        List<TownVillagerPatrol> found = new List<TownVillagerPatrol>();
        for (int i = 0; i < roots.Length; i++)
            found.AddRange(roots[i].GetComponentsInChildren<TownVillagerPatrol>(true));

        sb.AppendLine("gap = groundSurfaceY - meshBottomY   (negative = feet below ground / sunk)");
        sb.AppendLine();

        for (int i = 0; i < found.Count; i++)
        {
            TownVillagerPatrol v = found[i];
            if (!v.gameObject.activeInHierarchy) continue;

            // Collect this villager's own colliders so the ray ignores them.
            HashSet<int> mine = new HashSet<int>();
            Collider[] own = v.GetComponentsInChildren<Collider>(true);
            for (int c = 0; c < own.Length; c++)
                if (own[c] != null) mine.Add(own[c].GetInstanceID());

            Vector3 origin = v.transform.position + Vector3.up * 5f;
            float groundY = float.NaN;
            string groundName = "-";

            RaycastHit[] hits = Physics.RaycastAll(origin, Vector3.down, 40f, ~0, QueryTriggerInteraction.Ignore);
            float best = float.MinValue;
            for (int h = 0; h < hits.Length; h++)
            {
                if (mine.Contains(hits[h].collider.GetInstanceID())) continue;
                if (hits[h].point.y > best)
                {
                    best = hits[h].point.y;
                    groundName = hits[h].collider.name;
                }
            }
            if (best > float.MinValue) groundY = best;

            Renderer[] rs = v.GetComponentsInChildren<Renderer>(true);
            float meshMin = float.MaxValue;
            for (int r = 0; r < rs.Length; r++)
                if (rs[r] != null && rs[r].bounds.min.y < meshMin) meshMin = rs[r].bounds.min.y;

            sb.AppendLine(v.name.PadRight(28)
                          + " rootY=" + v.transform.position.y.ToString("F6")
                          + "  meshBottom=" + meshMin.ToString("F6")
                          + "  groundY=" + (float.IsNaN(groundY) ? "NONE" : groundY.ToString("F6"))
                          + "  gap=" + (float.IsNaN(groundY) ? "n/a" : (groundY - meshMin).ToString("F6"))
                          + "  on='" + groundName + "'");
        }

        sb.AppendLine();
        sb.AppendLine("=== navmesh Y directly under each villager ===");
        for (int i = 0; i < found.Count; i++)
        {
            TownVillagerPatrol v = found[i];
            if (!v.gameObject.activeInHierarchy) continue;
            Vector3 p = v.transform.position;
            if (NavMesh.SamplePosition(p, out NavMeshHit nh, 3f, NavMesh.AllAreas))
                sb.AppendLine("  " + v.name.PadRight(28) + " navmeshY=" + nh.position.y.ToString("F6")
                              + "  rootY-navmeshY=" + (p.y - nh.position.y).ToString("F6"));
            else
                sb.AppendLine("  " + v.name.PadRight(28) + " NO NAVMESH within 3m");
        }

        return sb.ToString();
    }
}
