using System.Text;
using UnityEditor;
using UnityEngine;

public static class AuraFogDistancePass
{
    const string ProfilePath = "Assets/Settings/LuminousLake_Atmosphere.asset";

    static readonly float[] Target = new float[] { 70f, 150f, 210f, 275f };

    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();

        Object asset = AssetDatabase.LoadAssetAtPath<Object>(ProfilePath);
        if (asset == null) return "ABORT: could not load " + ProfilePath;

        SerializedObject so = new SerializedObject(asset);

        sb.AppendLine("=== before -> after ===");
        for (int i = 1; i <= 4; i++)
        {
            SerializedProperty p = so.FindProperty("fogStart" + i);
            if (p == null) { sb.AppendLine("fogStart" + i + " : FIELD NOT FOUND"); continue; }

            SerializedProperty fv = p.FindPropertyRelative("floatVal");
            SerializedProperty mode = p.FindPropertyRelative("mode");
            SerializedProperty ov = p.FindPropertyRelative("overrideValue");

            if (fv == null) { sb.AppendLine("fogStart" + i + ".floatVal : NOT FOUND"); continue; }

            sb.AppendLine("fogStart" + i + "  mode=" + (mode != null ? mode.enumValueIndex.ToString() : "?") +
                          "  override=" + (ov != null ? ov.intValue.ToString() : "?") +
                          "  floatVal " + fv.floatValue.ToString("F4") + " -> " + Target[i - 1].ToString("F4"));

            fv.floatValue = Target[i - 1];
        }

        so.ApplyModifiedPropertiesWithoutUndo();
        EditorUtility.SetDirty(asset);
        AssetDatabase.SaveAssets();

        // Force a genuine disk round-trip, then re-read: an in-memory object proves nothing.
        AssetDatabase.ImportAsset(ProfilePath, ImportAssetOptions.ForceUpdate);

        Object reread = AssetDatabase.LoadAssetAtPath<Object>(ProfilePath);
        if (reread == null) { sb.AppendLine("ABORT: re-import read failed"); return sb.ToString(); }

        SerializedObject so2 = new SerializedObject(reread);
        sb.AppendLine();
        sb.AppendLine("=== after forced re-import (disk truth) ===");
        for (int i = 1; i <= 4; i++)
        {
            SerializedProperty p = so2.FindProperty("fogStart" + i);
            SerializedProperty fv = p != null ? p.FindPropertyRelative("floatVal") : null;
            sb.AppendLine("fogStart" + i + ".floatVal = " + (fv != null ? fv.floatValue.ToString("F4") : "MISSING"));
        }

        SerializedProperty dens = so2.FindProperty("fogDensityMultiplier");
        SerializedProperty densFv = dens != null ? dens.FindPropertyRelative("floatVal") : null;
        if (densFv != null)
            sb.AppendLine("fogDensityMultiplier.floatVal = " + densFv.floatValue.ToString("F4") + "   (untouched)");

        return sb.ToString();
    }
}
