using System;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace AuraWork
{
    public static class AuraAtmosphereAndVolume
    {
        private const string AtmoPath = "Assets/Settings/LuminousLake_Atmosphere.asset";
        private const string VolPath = "Assets/Settings/DefaultVolumeProfile.asset";

        // Authored scene time 06:30 -> COZY gradient time, established in an earlier pass.
        private const float AuthoredT = 0.2189f;

        public static string Execute()
        {
            var sb = new StringBuilder();

            // ================= ITEM 2 : COZY ATMOSPHERE FOG =================
            sb.AppendLine("=== ITEM 2: LuminousLake_Atmosphere ===");
            var atmo = AssetDatabase.LoadAssetAtPath<ScriptableObject>(AtmoPath);
            if (atmo == null) { sb.AppendLine("FAILED to load " + AtmoPath); return sb.ToString(); }

            var aso = new SerializedObject(atmo);
            string beforeDensity = aso.FindProperty("fogDensityMultiplier.floatVal").floatValue.ToString("F2");
            string beforeC4 = KeySummary(aso, "fogColor4");
            string beforeC5 = KeySummary(aso, "fogColor5");

            // Single global density multiplier. Near band (fogColor1) has gradient alpha ~0.008,
            // so thickening here pushes the mid/far bands without hazing the foreground.
            aso.FindProperty("fogDensityMultiplier.floatVal").floatValue = 26f;

            // fogColor4 governs the 170 m .. 265 m band. Alpha (coverage) left untouched.
            SetKey(aso, "fogColor4", 0, new Color(0.62f, 0.30f, 0.06f, 0.756863f));
            SetKey(aso, "fogColor4", 1, new Color(1.00f, 0.58f, 0.14f, 0.756863f));

            // fogColor5 governs 265 m .. beyond, i.e. the last band before the 300 m clip.
            SetKey(aso, "fogColor5", 0, new Color(1.00f, 0.47f, 0.10f, 1f));
            SetKey(aso, "fogColor5", 1, new Color(1.70f, 0.95f, 0.30f, 1f));

            aso.ApplyModifiedProperties();
            EditorUtility.SetDirty(atmo);

            var check = new SerializedObject(atmo);   // re-read
            sb.AppendLine("  fogDensityMultiplier : " + beforeDensity + " -> " +
                          check.FindProperty("fogDensityMultiplier.floatVal").floatValue.ToString("F2"));
            sb.AppendLine("  fogColor4 keys       : " + beforeC4 + " -> " + KeySummary(check, "fogColor4"));
            sb.AppendLine("  fogColor5 keys       : " + beforeC5 + " -> " + KeySummary(check, "fogColor5"));
            sb.AppendLine("  fogColor4 (t=0.2189) : " + EvalAt(check, "fogColor4", AuthoredT));
            sb.AppendLine("  fogColor5 (t=0.2189) : " + EvalAt(check, "fogColor5", AuthoredT));
            sb.AppendLine("  fogStart1..4 (left)  : " + F(check, "fogStart1") + ", " + F(check, "fogStart2") +
                          ", " + F(check, "fogStart3") + ", " + F(check, "fogStart4"));
            sb.AppendLine("  fogColor1 alpha (fg) : " + KeyAlpha(check, "fogColor1", 0).ToString("F4"));
            sb.AppendLine("  fogColor3  (untouched): " + KeySummary(check, "fogColor3"));

            // ================= ITEM 3 : VOLUME PROFILE =================
            sb.AppendLine("=== ITEM 3: DefaultVolumeProfile ===");
            var vp = AssetDatabase.LoadAssetAtPath<VolumeProfile>(VolPath);
            if (vp == null) { sb.AppendLine("FAILED to load " + VolPath); return sb.ToString(); }

            Bloom bloom = null;
            ColorAdjustments ca = null;
            foreach (var c in vp.components)
            {
                if (c is Bloom b) bloom = b;
                if (c is ColorAdjustments a) ca = a;
            }

            if (bloom != null)
            {
                var bso = new SerializedObject(bloom);
                sb.AppendLine("  Bloom before: intensity=" + GP(bso, "intensity") +
                              " threshold=" + GP(bso, "threshold") +
                              " scatter=" + GP(bso, "scatter") +
                              " hqFiltering=" + GBP(bso, "highQualityFiltering") +
                              " maxIterations=" + GP(bso, "maxIterations"));
                SetFloat(bso, "intensity", 0.85f);
                SetFloat(bso, "threshold", 0.75f);
                SetFloat(bso, "scatter", 0.78f);
                SetBool(bso, "highQualityFiltering", true);
                bso.ApplyModifiedProperties();
                EditorUtility.SetDirty(bloom);

                var b2 = new SerializedObject(bloom);
                sb.AppendLine("  Bloom after : intensity=" + GP(b2, "intensity") +
                              " threshold=" + GP(b2, "threshold") +
                              " scatter=" + GP(b2, "scatter") +
                              " hqFiltering=" + GBP(b2, "highQualityFiltering") +
                              " maxIterations=" + GP(b2, "maxIterations") +
                              " active=" + bloom.active);
            }
            else sb.AppendLine("  Bloom component NOT FOUND");

            if (ca != null)
            {
                var cso = new SerializedObject(ca);
                sb.AppendLine("  ColorAdjustments before: saturation=" + GP(cso, "saturation") +
                              " contrast=" + GP(cso, "contrast") +
                              " postExposure=" + GP(cso, "postExposure") +
                              " hueShift=" + GP(cso, "hueShift") +
                              " colorFilter=" + GCP(cso, "colorFilter"));
                SetFloat(cso, "saturation", 12f);
                SetFloat(cso, "contrast", 8f);
                SetColor(cso, "colorFilter", new Color(1.00f, 0.95f, 0.87f, 1f));
                cso.ApplyModifiedProperties();
                EditorUtility.SetDirty(ca);

                var c2 = new SerializedObject(ca);
                sb.AppendLine("  ColorAdjustments after : saturation=" + GP(c2, "saturation") +
                              " contrast=" + GP(c2, "contrast") +
                              " postExposure=" + GP(c2, "postExposure") +
                              " hueShift=" + GP(c2, "hueShift") +
                              " colorFilter=" + GCP(c2, "colorFilter") +
                              " active=" + ca.active);
            }
            else sb.AppendLine("  ColorAdjustments component NOT FOUND");

            AssetDatabase.SaveAssets();
            sb.AppendLine("AssetDatabase.SaveAssets() done.");

            return sb.ToString();
        }

        // ---------------- helpers ----------------

        private static void SetKey(SerializedObject so, string prop, int idx, Color c)
        {
            var p = so.FindProperty(prop + ".gradientVal.key" + idx);
            if (p != null) p.colorValue = c;
        }

        private static float KeyAlpha(SerializedObject so, string prop, int idx)
        {
            var p = so.FindProperty(prop + ".gradientVal.key" + idx);
            return p != null ? p.colorValue.a : -1f;
        }

        private static string KeySummary(SerializedObject so, string prop)
        {
            var p0 = so.FindProperty(prop + ".gradientVal.key0");
            var p1 = so.FindProperty(prop + ".gradientVal.key1");
            if (p0 == null || p1 == null) return "<none>";
            return "k0=" + p0.colorValue + " k1=" + p1.colorValue;
        }

        private static float F(SerializedObject so, string prop)
        {
            var p = so.FindProperty(prop + ".floatVal");
            return p != null ? p.floatValue : -999f;
        }

        private static string EvalAt(SerializedObject so, string prop, float t)
        {
            var g = new Gradient();
            var keys = so.FindProperty(prop + ".gradientVal");
            var ck = keys.FindPropertyRelative("key0");
            var k0 = ck.colorValue;
            var k1 = keys.FindPropertyRelative("key1").colorValue;
            float t0 = keys.FindPropertyRelative("ctime0").intValue / 65535f;
            float t1 = keys.FindPropertyRelative("ctime1").intValue / 65535f;
            float f = t1 > t0 ? Mathf.InverseLerp(t0, t1, t) : 0f;
            return "lerp(" + k0 + " -> " + k1 + ") at t=" + t.ToString("F4") + " =" + Color.Lerp(k0, k1, f);
        }

        private static void SetFloat(SerializedObject so, string name, float v)
        {
            var p = so.FindProperty(name + ".m_Value");
            var o = so.FindProperty(name + ".m_OverrideState");
            if (p != null) p.floatValue = v;
            if (o != null) o.boolValue = true;
        }

        private static void SetBool(SerializedObject so, string name, bool v)
        {
            var p = so.FindProperty(name + ".m_Value");
            var o = so.FindProperty(name + ".m_OverrideState");
            if (p != null) p.boolValue = v;
            if (o != null) o.boolValue = true;
        }

        private static void SetColor(SerializedObject so, string name, Color v)
        {
            var p = so.FindProperty(name + ".m_Value");
            var o = so.FindProperty(name + ".m_OverrideState");
            if (p != null) p.colorValue = v;
            if (o != null) o.boolValue = true;
        }

        private static string GP(SerializedObject so, string name)
        {
            var p = so.FindProperty(name + ".m_Value");
            return p == null ? "<none>" : p.floatValue.ToString("F3");
        }

        private static string GBP(SerializedObject so, string name)
        {
            var p = so.FindProperty(name + ".m_Value");
            return p == null ? "<none>" : p.boolValue.ToString();
        }

        private static string GCP(SerializedObject so, string name)
        {
            var p = so.FindProperty(name + ".m_Value");
            return p == null ? "<none>" : p.colorValue.ToString();
        }
    }
}
