using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using BigTigGames;

public static class AuraVillagerCensus
{
    static string PathOf(Transform t)
    {
        string p = t.name;
        while (t.parent != null) { t = t.parent; p = t.name + "/" + p; }
        return p;
    }

    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();
        Scene sc = SceneManager.GetActiveScene();
        sb.AppendLine("scene = " + sc.name + "  isLoaded=" + sc.isLoaded);

        GameObject[] roots = sc.GetRootGameObjects();
        List<TownVillagerPatrol> found = new List<TownVillagerPatrol>();
        for (int i = 0; i < roots.Length; i++)
            found.AddRange(roots[i].GetComponentsInChildren<TownVillagerPatrol>(true));

        sb.AppendLine("TownVillagerPatrol total = " + found.Count);

        int idx = 0;
        for (int i = 0; i < found.Count; i++)
        {
            TownVillagerPatrol v = found[i];
            NavMeshAgent a = v.GetComponent<NavMeshAgent>();
            sb.AppendLine("--- [" + (idx++) + "] " + PathOf(v.transform) + "  activeSelf=" + v.gameObject.activeSelf
                          + "  activeInHierarchy=" + v.gameObject.activeInHierarchy);
            sb.AppendLine("    pos = " + v.transform.position.ToString("F6"));

            if (a == null)
            {
                sb.AppendLine("    NO NavMeshAgent");
            }
            else
            {
                sb.AppendLine("    agent.enabled=" + a.enabled
                              + " baseOffset=" + a.baseOffset.ToString("F6")
                              + " height=" + a.height
                              + " radius=" + a.radius
                              + " stoppingDistance=" + a.stoppingDistance
                              + " speed=" + a.speed
                              + " areaMask=" + a.areaMask
                              + " updateRotation=" + a.updateRotation);
            }

            sb.AppendLine("    walkSpeed=" + v.walkSpeed
                          + " pingPong=" + v.pingPong
                          + " randomStreetDestinations=" + v.randomStreetDestinations
                          + " pauseOnlyAtEnds=" + v.pauseOnlyAtEnds
                          + " waypointTolerance=" + v.waypointTolerance);

            int wc = v.waypoints == null ? -1 : v.waypoints.Count;
            sb.AppendLine("    waypoints.Count = " + wc);
            if (v.waypoints != null)
            {
                for (int w = 0; w < v.waypoints.Count; w++)
                    sb.AppendLine("      wp[" + w + "] = " + v.waypoints[w].ToString("F6"));
            }

            sb.AppendLine("    marketplaceStalls = " + (v.marketplaceStalls == null ? -1 : v.marketplaceStalls.Count));
        }

        Vector3[] probes = new Vector3[]
        {
            new Vector3(616.20f, 30f, 245.70f),
            new Vector3(630.00f, 30f, 245.70f),
            new Vector3(630.00f, 30f, 233.00f),
            new Vector3(716.50f, 30f, 233.00f),
            new Vector3(716.50f, 30f, 260.00f)
        };

        sb.AppendLine();
        sb.AppendLine("=== ground raycast (straight down from y=30) ===");
        for (int i = 0; i < probes.Length; i++)
        {
            if (Physics.Raycast(probes[i], Vector3.down, out RaycastHit hit, 60f))
            {
                sb.AppendLine("  probe" + i + " " + probes[i].ToString("F2")
                              + " -> hit Y " + hit.point.y.ToString("F6")
                              + "  collider='" + hit.collider.name + "'");
            }
            else
            {
                sb.AppendLine("  probe" + i + " " + probes[i].ToString("F2") + " -> NO HIT");
            }
        }

        sb.AppendLine();
        sb.AppendLine("=== NavMesh.SamplePosition at the same street points ===");
        for (int i = 0; i < probes.Length; i++)
        {
            if (NavMesh.SamplePosition(probes[i], out NavMeshHit nh, 5f, NavMesh.AllAreas))
            {
                sb.AppendLine("  probe" + i + " -> navmesh Y " + nh.position.y.ToString("F6")
                              + "  dist=" + nh.distance.ToString("F4"));
            }
            else
            {
                sb.AppendLine("  probe" + i + " -> NO NAVMESH");
            }
        }

        NavMeshTriangulation tri = NavMesh.CalculateTriangulation();
        sb.AppendLine();
        sb.AppendLine("navmesh vertices = " + (tri.vertices == null ? 0 : tri.vertices.Length)
                      + "   triangles = " + (tri.indices == null ? 0 : tri.indices.Length / 3));

        return sb.ToString();
    }
}
