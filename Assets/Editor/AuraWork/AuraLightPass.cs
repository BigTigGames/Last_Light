using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class AuraLightPass
{
    const string ProfilePath = "Assets/Settings/LuminousLake_Atmosphere.asset";

    static readonly Vector3 REF_POS = new Vector3(715.32580f, 11.52654f, 222.06380f);
    static readonly Vector3 REF_EULER = new Vector3(359.69170f, 357.66090f, 0.00025f);

    // --- authored originals (sunlightColor.gradientVal, mode:0 so gradientVal is the live field) ---
    static readonly Color[] SUN_ORIG = new Color[]
    {
        new Color(0f,          0f,          0f,          1f),          // key0
        new Color(0f,          0f,          0f,          1f),          // key1
        new Color(0.70987976f, 0.41039923f, 0.33830208f, 0f),          // key2
        new Color(1.375392f,   1.3476623f,  1.1535546f,  0f),          // key3
        new Color(1.375392f,   1.3476623f,  1.1535546f,  0f),          // key4
        new Color(1.7812133f,  0.84896535f, 0.6133423f,  0f),          // key5
        new Color(0f,          0f,          0f,          0f),          // key6
        new Color(0f,          0f,          0f,          0f),          // key7
    };

    const float SUN_ORIG_LUMA_DAY = 1.3395f;   // luma of key3/key4: the noon plateau
    const float AMB_ORIG = 2f;

    // ------------------------------------------------------------------ camera

    public static string Pin()
    {
        var cam = Camera.main;
        if (cam == null) return "NO MAIN CAMERA";
        var t = cam.transform;
        t.position = REF_POS;
        t.rotation = Quaternion.Euler(REF_EULER);
        int disabled = 0;
        foreach (var c in t.GetComponents<Component>())
        {
            var b = c as Behaviour;
            if (b == null || !b.enabled) continue;
            var n = c.GetType().Name;
            if (n == "FreeCamera" || n.Contains("CameraController") || n.Contains("CameraRig") || n.Contains("FlyCamera"))
            { b.enabled = false; disabled++; }
        }
        return "PIN disabled=" + disabled + " drift=" + (t.position - REF_POS).magnitude.ToString("F4");
    }

    // ----------------------------------------------------------------- profile

    static SerializedObject Open()
    {
        var obj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(ProfilePath);
        return new SerializedObject(obj);
    }

    static void Commit(SerializedObject so, UnityEngine.Object obj, string tag, StringBuilder sb)
    {
        so.ApplyModifiedPropertiesWithoutUndo();
        EditorUtility.SetDirty(obj);
        AssetDatabase.SaveAssets();
        AssetDatabase.ImportAsset(ProfilePath, ImportAssetOptions.ForceUpdate);
        so.Dispose();

        // prove disk with a fresh read
        var so2 = Open();
        sb.AppendLine(tag + " DISK " + State(so2));
        so2.Dispose();
    }

    static string State(SerializedObject so)
    {
        var g = so.FindProperty("sunlightColor").FindPropertyRelative("gradientVal");
        var sb = new StringBuilder("sun=[");
        for (int i = 0; i < 8; i++)
        {
            var k = g.FindPropertyRelative("key" + i).colorValue;
            if (i >= 2 && i <= 5) sb.Append("k" + i + "(" + k.r.ToString("F4") + "," + k.g.ToString("F4") + "," + k.b.ToString("F4") + ")");
        }
        sb.Append("] ambient=" + so.FindProperty("ambientLightMultiplier").FindPropertyRelative("floatVal").floatValue.ToString("R"));
        sb.Append(" | fog M=" + so.FindProperty("fogDensityMultiplier").FindPropertyRelative("floatVal").floatValue.ToString("R")
            + " S=" + so.FindProperty("fogStart1").FindPropertyRelative("floatVal").floatValue.ToString("R")
            + "/" + so.FindProperty("fogStart2").FindPropertyRelative("floatVal").floatValue.ToString("R")
            + "/" + so.FindProperty("fogStart3").FindPropertyRelative("floatVal").floatValue.ToString("R")
            + "/" + so.FindProperty("fogStart4").FindPropertyRelative("floatVal").floatValue.ToString("R"));
        return sb.ToString();
    }

    // ----------------------------------------------------------------- actions

    static string SetSun(float factor)
    {
        var sb = new StringBuilder();
        var obj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(ProfilePath);
        var so = new SerializedObject(obj);
        var g = so.FindProperty("sunlightColor").FindPropertyRelative("gradientVal");
        for (int i = 0; i < 8; i++)
        {
            var p = g.FindPropertyRelative("key" + i);
            var o = SUN_ORIG[i];
            var c = new Color(o.r * factor, o.g * factor, o.b * factor, o.a);   // alpha preserved
            p.colorValue = c;
        }
        Commit(so, obj, "SUNx" + factor.ToString("F2"), sb);
        sb.AppendLine("effectiveSunLumaAtNoon = " + (AMB_ORIG * 0f + 2f * SUN_ORIG_LUMA_DAY * factor).ToString("F4")
            + "  (light intensity 2 x colour luma)");
        return sb.ToString();
    }

    public static string Sun88() { return Pin() + "\n" + SetSun(0.88f); }
    public static string Sun85() { return Pin() + "\n" + SetSun(0.85f); }
    public static string Sun100() { return Pin() + "\n" + SetSun(1f); }

    static string SetAmbient(float v)
    {
        var sb = new StringBuilder();
        var obj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(ProfilePath);
        var so = new SerializedObject(obj);
        so.FindProperty("ambientLightMultiplier").FindPropertyRelative("floatVal").floatValue = v;
        Commit(so, obj, "AMB" + v.ToString("F2"), sb);
        return sb.ToString();
    }

    public static string Amb175() { return Pin() + "\n" + SetAmbient(1.75f); }
    public static string Amb150() { return Pin() + "\n" + SetAmbient(1.5f); }
    public static string Amb200() { return Pin() + "\n" + SetAmbient(AMB_ORIG); }

    public static string Execute()
    {
        var sb = new StringBuilder();
        sb.AppendLine(Pin());
        var so = Open();
        sb.AppendLine("STATE " + State(so));
        so.Dispose();
        var w = Find();
        if (w != null)
            sb.AppendLine("LIVE sunCol=" + F(w.sunlightColor) + " ambientMult=" + w.ambientLightMultiplier.ToString("R")
                + " ambientSky=" + F(RenderSettings.ambientSkyColor) + " ambientEq=" + F(RenderSettings.ambientEquatorColor));
        return sb.ToString();
    }

    public static string Live()
    {
        var sb = new StringBuilder();
        var w = Find();
        if (w != null)
        {
            sb.AppendLine("LIVE sunCol=" + F(w.sunlightColor) + " luma=" + Lum(w.sunlightColor).ToString("F4")
                + " ambientMult=" + w.ambientLightMultiplier.ToString("R"));
            if (w.sunLight != null)
                sb.AppendLine("SUNLIGHT intensity=" + w.sunLight.intensity.ToString("R") + " color=" + F(w.sunLight.color)
                    + " luma=" + Lum(w.sunLight.color).ToString("F4"));
        }
        sb.AppendLine("RenderSettings ambientSky=" + F(RenderSettings.ambientSkyColor) + " luma=" + Lum(RenderSettings.ambientSkyColor).ToString("F4"));
        sb.AppendLine("RenderSettings ambientEq=" + F(RenderSettings.ambientEquatorColor) + " luma=" + Lum(RenderSettings.ambientEquatorColor).ToString("F4"));
        sb.AppendLine("RenderSettings ambientGround=" + F(RenderSettings.ambientGroundColor) + " luma=" + Lum(RenderSettings.ambientGroundColor).ToString("F4"));
        return sb.ToString();
    }

    static DistantLands.Cozy.CozyWeather Find()
    {
        var scene = SceneManager.GetActiveScene();
        foreach (var r in scene.GetRootGameObjects())
            foreach (var c in r.GetComponentsInChildren<Component>(true))
            {
                var w = c as DistantLands.Cozy.CozyWeather;
                if (w != null) return w;
            }
        return null;
    }

    static string F(Color c) { return "(" + c.r.ToString("F4") + "," + c.g.ToString("F4") + "," + c.b.ToString("F4") + ")"; }
    static float Lum(Color c) { return 0.2126f * c.r + 0.7152f * c.g + 0.0722f * c.b; }
}
