using System.Collections.Generic;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;
using BigTigGames;

public static class AuraVillagerFootProbe
{
    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();
        Scene sc = SceneManager.GetActiveScene();
        GameObject[] roots = sc.GetRootGameObjects();

        List<TownVillagerPatrol> found = new List<TownVillagerPatrol>();
        for (int i = 0; i < roots.Length; i++)
            found.AddRange(roots[i].GetComponentsInChildren<TownVillagerPatrol>(true));

        sb.AppendLine("=== per-villager foot measurement (world bounds) ===");
        for (int i = 0; i < found.Count; i++)
        {
            TownVillagerPatrol v = found[i];
            if (!v.gameObject.activeInHierarchy) continue;

            Renderer[] rs = v.GetComponentsInChildren<Renderer>(true);
            float minY = float.MaxValue;
            string lowest = "-";
            for (int r = 0; r < rs.Length; r++)
            {
                if (rs[r] == null) continue;
                if (rs[r].bounds.min.y < minY) { minY = rs[r].bounds.min.y; lowest = rs[r].name; }
            }

            SkinnedMeshRenderer[] smrs = v.GetComponentsInChildren<SkinnedMeshRenderer>(true);
            float skMin = float.MaxValue;
            for (int s = 0; s < smrs.Length; s++)
                if (smrs[s] != null && smrs[s].bounds.min.y < skMin) skMin = smrs[s].bounds.min.y;

            sb.AppendLine(v.name
                          + "  rootY=" + v.transform.position.y.ToString("F6")
                          + "  allMinY=" + (rs.Length == 0 ? 0f : minY).ToString("F6")
                          + "  skinnedMinY=" + (smrs.Length == 0 ? 0f : skMin).ToString("F6")
                          + "  renderers=" + rs.Length
                          + "  lowest='" + lowest + "'");
        }

        sb.AppendLine();
        sb.AppendLine("=== NavMesh.SamplePosition sweep (varying radius) ===");
        Vector3[] pts = new Vector3[]
        {
            new Vector3(616.20f, 10.16f, 245.70f),
            new Vector3(673.00f, 10.16f, 250.00f),
            new Vector3(716.50f, 10.16f, 233.00f)
        };
        float[] rads = new float[] { 0.5f, 2f, 5f, 25f };
        for (int p = 0; p < pts.Length; p++)
        {
            for (int r = 0; r < rads.Length; r++)
            {
                if (NavMesh.SamplePosition(pts[p], out NavMeshHit h, rads[r], NavMesh.AllAreas))
                    sb.AppendLine("  " + pts[p].ToString("F2") + " r=" + rads[r]
                                  + " -> Y " + h.position.y.ToString("F6"));
                else
                    sb.AppendLine("  " + pts[p].ToString("F2") + " r=" + rads[r] + " -> none");
            }
        }

        sb.AppendLine();
        sb.AppendLine("=== agent navmesh state (edit mode) ===");
        for (int i = 0; i < found.Count; i++)
        {
            NavMeshAgent a = found[i].GetComponent<NavMeshAgent>();
            if (a == null) continue;
            sb.AppendLine("  " + found[i].name
                          + "  isOnNavMesh=" + a.isOnNavMesh
                          + "  hasPath=" + a.hasPath
                          + "  isStopped=" + a.isStopped
                          + "  baseOffset=" + a.baseOffset.ToString("F6"));
        }

        sb.AppendLine();
        sb.AppendLine("=== NavMeshSurface components in scene ===");
        int surfaces = 0;
        for (int i = 0; i < roots.Length; i++)
        {
            MonoBehaviour[] all = roots[i].GetComponentsInChildren<MonoBehaviour>(true);
            for (int m = 0; m < all.Length; m++)
            {
                if (all[m] == null) continue;
                if (all[m].GetType().Name != "NavMeshSurface") continue;
                surfaces++;

                SerializedObject so = new SerializedObject(all[m]);
                SerializedProperty data = so.FindProperty("m_NavMeshData");
                sb.AppendLine("  surface on '" + all[m].gameObject.name + "'  navMeshData="
                              + (data == null || data.objectReferenceValue == null ? "NULL" : data.objectReferenceValue.name));

                SerializedProperty bs = so.FindProperty("m_BuildSettings");
                if (bs != null)
                {
                    SerializedProperty ag = bs.FindPropertyRelative("agentTypeID");
                    SerializedProperty cs = bs.FindPropertyRelative("collectObjects");
                    SerializedProperty gs = bs.FindPropertyRelative("useGeometry");
                    SerializedProperty cl = bs.FindPropertyRelative("layerMask");
                    SerializedProperty ov = bs.FindPropertyRelative("overrideVoxelSize");
                    SerializedProperty vs = bs.FindPropertyRelative("voxelSize");
                    sb.AppendLine("      agentTypeID=" + (ag != null ? ag.intValue.ToString() : "?")
                                  + " collectObjects=" + (cs != null ? cs.intValue.ToString() : "?")
                                  + " useGeometry=" + (gs != null ? gs.intValue.ToString() : "?")
                                  + " layerMask=" + (cl != null ? cl.intValue.ToString() : "?")
                                  + " overrideVoxel=" + (ov != null ? ov.boolValue.ToString() : "?")
                                  + " voxelSize=" + (vs != null ? vs.floatValue.ToString("F6") : "?"));
                }
            }
        }
        sb.AppendLine("NavMeshSurface count = " + surfaces);

        return sb.ToString();
    }
}
