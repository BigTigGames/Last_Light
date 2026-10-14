using System;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace AuraWork
{
    public static class AuraReconVfxPass
    {
        public static string Execute()
        {
            var sb = new StringBuilder();

            // ---------- C. Atmosphere profile : fog fields ----------
            sb.AppendLine("=== C. LuminousLake_Atmosphere TOP-LEVEL FIELDS ===");
            var atmo = AssetDatabase.LoadAssetAtPath<ScriptableObject>("Assets/Settings/LuminousLake_Atmosphere.asset");
            sb.AppendLine("loaded: " + (atmo != null ? atmo.GetType().FullName : "<null>"));
            if (atmo != null)
            {
                var aso = new SerializedObject(atmo);
                var it = aso.GetIterator();
                it.NextVisible(true);                 // position on root
                while (it.NextVisible(false))         // walk the depth-1 children
                {
                    sb.Append("  ").Append(it.name).Append(" [").Append(it.propertyType).Append("]");

                    var fv = aso.FindProperty(it.propertyPath + ".floatVal");
                    if (fv != null) sb.Append(" floatVal=").Append(fv.floatValue);
                    var md = aso.FindProperty(it.propertyPath + ".mode");
                    if (md != null) sb.Append(" mode=").Append(md.intValue);
                    var ov = aso.FindProperty(it.propertyPath + ".overrideValue");
                    if (ov != null) sb.Append(" override=").Append(ov.intValue);
                    var cv = aso.FindProperty(it.propertyPath + ".colorVal");
                    if (cv != null) sb.Append(" colorVal=").Append(cv.colorValue);

                    if (it.propertyType == SerializedPropertyType.Float) sb.Append(" raw=").Append(it.floatValue);
                    if (it.propertyType == SerializedPropertyType.Integer) sb.Append(" raw=").Append(it.intValue);
                    if (it.propertyType == SerializedPropertyType.Vector3) sb.Append(" raw=").Append(it.vector3Value);
                    sb.AppendLine();
                }
            }

            // ---------- D. Volume profile ----------
            sb.AppendLine("=== D. DefaultVolumeProfile ===");
            var vp = AssetDatabase.LoadAssetAtPath<VolumeProfile>("Assets/Settings/DefaultVolumeProfile.asset");
            sb.AppendLine("loaded: " + (vp != null ? vp.GetType().FullName : "<null>"));
            if (vp != null)
            {
                sb.AppendLine("components: " + vp.components.Count);
                foreach (var c in vp.components)
                {
                    if (c == null) { sb.AppendLine("  <null>"); continue; }
                    string tn = c.GetType().Name;
                    var so = new SerializedObject(c);
                    var act = so.FindProperty("active");
                    string activeStr = act != null ? act.boolValue.ToString() : c.active.ToString();
                    sb.AppendLine("  " + tn + " active=" + activeStr);
                    if (tn == "Bloom" || tn == "ColorAdjustments") DumpParams(sb, c, "      ");
                }
            }

            return sb.ToString();
        }

        private static void DumpParams(StringBuilder sb, VolumeComponent comp, string indent)
        {
            var cso = new SerializedObject(comp);
            var it = cso.GetIterator();
            it.NextVisible(true);
            while (it.NextVisible(false))
            {
                sb.Append(indent).Append(it.name).Append(" [").Append(it.propertyType).Append("]");
                var ov = cso.FindProperty(it.propertyPath + ".m_OverrideState");
                if (ov != null) sb.Append(" override=").Append(ov.boolValue);
                var val = cso.FindProperty(it.propertyPath + ".m_Value");
                if (val != null)
                {
                    switch (val.propertyType)
                    {
                        case SerializedPropertyType.Float: sb.Append(" value=").Append(val.floatValue); break;
                        case SerializedPropertyType.Integer: sb.Append(" value=").Append(val.intValue); break;
                        case SerializedPropertyType.Boolean: sb.Append(" value=").Append(val.boolValue); break;
                        case SerializedPropertyType.Color: sb.Append(" value=").Append(val.colorValue); break;
                        case SerializedPropertyType.Vector2: sb.Append(" value=").Append(val.vector2Value); break;
                        default: sb.Append(" value=<").Append(val.propertyType).Append(">"); break;
                    }
                }
                sb.AppendLine();
            }
        }
    }
}
