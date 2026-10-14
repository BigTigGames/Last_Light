using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public static class AuraProbeVillagers
{
    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();

        // ---------- Is there a NavMesh at all? ----------
        try
        {
            NavMeshTriangulation tri = NavMesh.CalculateTriangulation();
            int v = tri.vertices != null ? tri.vertices.Length : 0;
            int i3 = tri.indices != null ? tri.indices.Length : 0;
            sb.AppendLine("NAVMESH vertices = " + v + "   triangles = " + (i3 / 3));
        }
        catch (System.Exception e)
        {
            sb.AppendLine("NAVMESH probe threw: " + e.GetType().Name + " " + e.Message);
        }

        int townStreetArea = NavMesh.GetAreaFromName("Town_Street");
        sb.AppendLine("NavMesh area 'Town_Street' index = " + townStreetArea);

        // ---------- Walk the active scene ----------
        Scene scene = SceneManager.GetActiveScene();
        GameObject[] roots = scene.GetRootGameObjects();

        List<Transform> all = new List<Transform>();
        Stack<Transform> stack = new Stack<Transform>();
        for (int i = 0; i < roots.Length; i++) stack.Push(roots[i].transform);
        while (stack.Count > 0)
        {
            Transform t = stack.Pop();
            all.Add(t);
            for (int i = 0; i < t.childCount; i++) stack.Push(t.GetChild(i));
        }
        sb.AppendLine("scene transform count = " + all.Count);

        int found = 0;
        for (int i = 0; i < all.Count; i++)
        {
            Transform t = all[i];
            Component patrol = null;
            Component[] cs = t.GetComponents<Component>();
            for (int c = 0; c < cs.Length; c++)
            {
                if (cs[c] == null) continue;
                if (cs[c].GetType().Name == "TownVillagerPatrol") { patrol = cs[c]; break; }
            }
            if (patrol == null) continue;

            found++;
            NavMeshAgent a = t.GetComponent<NavMeshAgent>();

            sb.AppendLine("--- [" + found + "] " + Path(t));
            sb.AppendLine("      activeInHierarchy = " + t.gameObject.activeInHierarchy +
                          "   activeSelf = " + t.gameObject.activeSelf);
            sb.AppendLine("      position          = " + t.position.x.ToString("F4") + ", " +
                          t.position.y.ToString("F6") + ", " + t.position.z.ToString("F4"));

            if (a == null)
            {
                sb.AppendLine("      NavMeshAgent      = NONE");
            }
            else
            {
                sb.AppendLine("      agent.baseOffset  = " + a.baseOffset.ToString("F6"));
                sb.AppendLine("      agent.enabled     = " + a.enabled +
                              "   areaMask = " + a.areaMask);
                sb.AppendLine("      agent.height/radius = " + a.height.ToString("F3") + " / " +
                              a.radius.ToString("F3"));
            }

            System.Reflection.FieldInfo gf = patrol.GetType().GetField("groundOffset");
            if (gf != null) sb.AppendLine("      groundOffset      = " + gf.GetValue(patrol));

            System.Reflection.FieldInfo wp = patrol.GetType().GetField("waypoints");
            if (wp != null)
            {
                var list = wp.GetValue(patrol) as System.Collections.IList;
                sb.AppendLine("      waypoints.Count   = " + (list == null ? -1 : list.Count));
                if (list != null)
                {
                    for (int k = 0; k < list.Count; k++)
                    {
                        Vector3 v = (Vector3)list[k];
                        sb.AppendLine("         wp[" + k + "] = " + v.x.ToString("F4") + ", " +
                                      v.y.ToString("F6") + ", " + v.z.ToString("F4"));
                    }
                }
            }
        }

        sb.AppendLine("TOTAL TownVillagerPatrol in active scene = " + found);
        return sb.ToString();
    }

    static string Path(Transform t)
    {
        string s = t.name;
        while (t.parent != null) { t = t.parent; s = t.name + "/" + s; }
        return s;
    }
}
