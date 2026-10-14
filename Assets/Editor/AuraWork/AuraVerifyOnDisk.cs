using System;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace AuraWork
{
    public static class AuraVerifyOnDisk
    {
        private const string AtmoPath = "Assets/Settings/LuminousLake_Atmosphere.asset";
        private const string VolPath = "Assets/Settings/DefaultVolumeProfile.asset";

        public static string Execute()
        {
            var sb = new StringBuilder();

            // Force a re-import so the objects below are rebuilt FROM DISK, not from memory.
            AssetDatabase.ImportAsset(AtmoPath, ImportAssetOptions.ForceUpdate);
            AssetDatabase.ImportAsset(VolPath, ImportAssetOptions.ForceUpdate);

            sb.AppendLine("=== ATMOSPHERE (re-imported from disk) ===");
            var atmo = AssetDatabase.LoadAssetAtPath<ScriptableObject>(AtmoPath);
            if (atmo == null) sb.AppendLine("  <null>");
            else
            {
                var so = new SerializedObject(atmo);
                sb.AppendLine("  fogDensityMultiplier = " + so.FindProperty("fogDensityMultiplier.floatVal").floatValue);
                foreach (var p in new[] { "fogColor1", "fogColor4", "fogColor5" })
                    sb.AppendLine("  " + p + " k0=" + so.FindProperty(p + ".gradientVal.key0").colorValue +
                                  "  k1=" + so.FindProperty(p + ".gradientVal.key1").colorValue);
                sb.AppendLine("  fogStart1..4 = " + so.FindProperty("fogStart1.floatVal").floatValue + ", " +
                              so.FindProperty("fogStart2.floatVal").floatValue + ", " +
                              so.FindProperty("fogStart3.floatVal").floatValue + ", " +
                              so.FindProperty("fogStart4.floatVal").floatValue);
            }

            sb.AppendLine("=== VOLUME PROFILE (re-imported from disk) ===");
            var vp = AssetDatabase.LoadAssetAtPath<VolumeProfile>(VolPath);
            if (vp == null) sb.AppendLine("  <null>");
            else
            {
                sb.AppendLine("  components = " + vp.components.Count);
                foreach (var c in vp.components)
                {
                    if (c == null) continue;
                    if (c is Bloom b)
                    {
                        var bs = new SerializedObject(b);
                        sb.AppendLine("  Bloom intensity=" + F(bs, "intensity") + " threshold=" + F(bs, "threshold") +
                                      " scatter=" + F(bs, "scatter") + " hq=" + B(bs, "highQualityFiltering") +
                                      " active=" + b.active);
                    }
                    if (c is ColorAdjustments a)
                    {
                        var cs = new SerializedObject(a);
                        sb.AppendLine("  ColorAdjustments saturation=" + F(cs, "saturation") + " contrast=" + F(cs, "contrast") +
                                      " colorFilter=" + C(cs, "colorFilter") + " active=" + a.active);
                    }
                }
            }

            // RP asset sanity - the 90 m / 4096 pass must still be intact
            sb.AppendLine("=== PC_RPAsset (unchanged by this pass) ===");
            var rp = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>("Assets/Settings/PC_RPAsset.asset");
            if (rp != null)
            {
                var rs = new SerializedObject(rp);
                sb.AppendLine("  m_ShadowDistance = " + rs.FindProperty("m_ShadowDistance").floatValue +
                              "  m_MainLightShadowmapResolution = " + rs.FindProperty("m_MainLightShadowmapResolution").intValue);
            }

            // emitter census
            sb.AppendLine("=== VFX CROWD ===");
            var mgr = GameObject.Find("_SYSTEM_MANAGERS");
            var crowd = mgr != null ? mgr.transform.Find("_ENVIRONMENT_VFX_CROWD") : null;
            if (crowd == null) sb.AppendLine("  _SYSTEM_MANAGERS/_ENVIRONMENT_VFX_CROWD NOT FOUND");
            else
            {
                sb.AppendLine("  children of crowd = " + crowd.childCount);
                foreach (Transform g in crowd)
                    sb.AppendLine("    " + g.name.PadRight(24) + " emitters=" + g.childCount +
                                  " particleSystems=" + g.GetComponentsInChildren<ParticleSystem>(true).Length);
                sb.AppendLine("  total emitters = " + crowd.GetComponentsInChildren<ParticleSystem>(true).Length);
            }

            return sb.ToString();
        }

        private static string F(SerializedObject so, string n)
        {
            var p = so.FindProperty(n + ".m_Value");
            return p == null ? "?" : p.floatValue.ToString("F3");
        }

        private static string B(SerializedObject so, string n)
        {
            var p = so.FindProperty(n + ".m_Value");
            return p == null ? "?" : p.boolValue.ToString();
        }

        private static string C(SerializedObject so, string n)
        {
            var p = so.FindProperty(n + ".m_Value");
            return p == null ? "?" : p.colorValue.ToString();
        }
    }
}
