using System;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.SceneManagement;

public static class AuraGradeSetup
{
    const string DstPath    = "Assets/Settings/LuminousLake_GradeProfile.asset";
    const string VolumeName = "Grade_Volume";
    const string ParentName = "_SYSTEM_MANAGERS";

    // ---- A : current effective grading, reproduced exactly --------------
    const int   A_MODE = 0;      // 0 = None, 1 = Neutral, 2 = ACES
    const float A_THR  = 0.75f;
    const float A_INT  = 0.85f;

    // ---- B : Tonemapping Neutral, bloom untouched -----------------------
    const int   B_MODE = 1;
    const float B_THR  = A_THR;
    const float B_INT  = A_INT;

    // ---- C : Tonemapping Neutral + restrained bloom ---------------------
    const int   C_MODE = 1;
    const float C_THR  = 1.1f;
    const float C_INT  = 0.15f;

    // ---- bloom constants preserved across every config ------------------
    const float K_SCATTER = 0.78f;
    const float K_CLAMP   = 65472f;
    const int   K_ITER    = 6;

    // ===================================================== entry points

    public static string Execute()
    {
        try { return Setup(); } catch (Exception e) { return Err(e); }
    }

    public static string Verify()
    {
        try { return Dump(); } catch (Exception e) { return Err(e); }
    }

    public static string A() { try { return Apply("A", A_MODE, A_THR, A_INT); } catch (Exception e) { return Err(e); } }
    public static string B() { try { return Apply("B", B_MODE, B_THR, B_INT); } catch (Exception e) { return Err(e); } }
    public static string C() { try { return Apply("C", C_MODE, C_THR, C_INT); } catch (Exception e) { return Err(e); } }

    // ===================================================== setup (edit mode)

    static string Setup()
    {
        var sb = new StringBuilder();
        var scene = SceneManager.GetActiveScene();
        sb.AppendLine("SCENE " + scene.path);

        var parent = FindRoot(ParentName);
        if (parent == null) return "FAIL: root '" + ParentName + "' not found";

        if (AssetDatabase.LoadAssetAtPath<VolumeProfile>(DstPath) != null)
        {
            AssetDatabase.DeleteAsset(DstPath);
            sb.AppendLine("removed pre-existing profile");
        }

        var profile = ScriptableObject.CreateInstance<VolumeProfile>();
        profile.name = "LuminousLake_GradeProfile";
        AssetDatabase.CreateAsset(profile, DstPath);

        var tone = profile.Add<Tonemapping>(true);
        tone.hideFlags = HideFlags.HideInInspector | HideFlags.HideInHierarchy;
        AssetDatabase.AddObjectToAsset(tone, profile);

        var bloom = profile.Add<Bloom>(true);
        bloom.hideFlags = HideFlags.HideInInspector | HideFlags.HideInHierarchy;
        AssetDatabase.AddObjectToAsset(bloom, profile);

        Write(profile, A_MODE, A_THR, A_INT);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        sb.AppendLine("profile created " + DstPath);

        var vol = FindVolume();
        if (vol == null)
        {
            var go = new GameObject(VolumeName);
            go.layer = 0;
            go.transform.SetParent(parent.transform, false);
            vol = go.AddComponent<Volume>();
            sb.AppendLine("volume object created under " + ParentName);
        }
        vol.isGlobal = true;
        vol.priority = 0f;
        vol.weight   = 1f;
        vol.sharedProfile = profile;

        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        sb.AppendLine("scene saved");

        sb.AppendLine(Dump());
        return sb.ToString();
    }

    // ===================================================== A / B / C

    static string Apply(string tag, int mode, float thr, float intensity)
    {
        var profile = AssetDatabase.LoadAssetAtPath<VolumeProfile>(DstPath);
        if (profile == null) return "FAIL: no profile at " + DstPath;

        Write(profile, mode, thr, intensity);
        EditorUtility.SetDirty(profile);
        AssetDatabase.SaveAssets();
        AssetDatabase.ImportAsset(DstPath, ImportAssetOptions.ForceUpdate);

        var vol = FindVolume();
        return "CONFIG " + tag
            + " mode=" + mode + " thr=" + thr + " int=" + intensity
            + " | volume=" + (vol == null ? "MISSING" : PathOf(vol.transform)
                + " global=" + vol.isGlobal + " prio=" + vol.priority
                + " layer=" + LayerMask.LayerToName(vol.gameObject.layer)
                + " profile=" + (vol.sharedProfile == null ? "NULL" : AssetDatabase.GetAssetPath(vol.sharedProfile)))
            + "\n" + Prop(profile);
    }

    static void Write(VolumeProfile profile, int mode, float thr, float intensity)
    {
        Tonemapping t;
        if (profile.TryGet(out t))
        {
            t.mode.value = (TonemappingMode)mode;
            t.active = true;
        }
        Bloom b;
        if (profile.TryGet(out b))
        {
            b.threshold.value = thr;
            b.intensity.value = intensity;
            b.scatter.value = K_SCATTER;
            b.clamp.value = K_CLAMP;
            b.tint.value = Color.white;
            b.highQualityFiltering.value = true;
            b.filter.value = BloomFilterMode.Gaussian;
            b.downscale.value = BloomDownscaleMode.Half;
            b.maxIterations.value = K_ITER;
            b.dirtIntensity.value = 0f;
            b.dirtTexture.value = null;
            b.active = true;
        }
        EditorUtility.SetDirty(profile);
    }

    // ===================================================== on-disk proof

    static string Dump()
    {
        var sb = new StringBuilder();
        var profile = AssetDatabase.LoadAssetAtPath<VolumeProfile>(DstPath);
        if (profile == null) return "DISK profile MISSING at " + DstPath;

        sb.AppendLine("DISK " + DstPath + " components=" + profile.components.Count);
        foreach (var c in profile.components)
            sb.AppendLine("   " + (c == null ? "<null>" : c.GetType().Name + " active=" + c.active));

        Tonemapping t;
        if (profile.TryGet(out t))
            sb.AppendLine("  Tone mode=" + t.mode.value + "[" + t.mode.overrideState + "]");
        Bloom b;
        if (profile.TryGet(out b))
            sb.AppendLine("  Bloom thr=" + b.threshold.value + "[" + b.threshold.overrideState + "]"
                + " int=" + b.intensity.value + "[" + b.intensity.overrideState + "]"
                + " scatter=" + b.scatter.value + "[" + b.scatter.overrideState + "]"
                + " clamp=" + b.clamp.value + "[" + b.clamp.overrideState + "]"
                + " hq=" + b.highQualityFiltering.value + "[" + b.highQualityFiltering.overrideState + "]"
                + " filter=" + b.filter.value + "[" + b.filter.overrideState + "]"
                + " downscale=" + b.downscale.value + "[" + b.downscale.overrideState + "]"
                + " maxIter=" + b.maxIterations.value + "[" + b.maxIterations.overrideState + "]");

        var vol = FindVolume();
        sb.AppendLine("  volume=" + (vol == null ? "MISSING" : PathOf(vol.transform)
            + " global=" + vol.isGlobal + " prio=" + vol.priority
            + " layer=" + LayerMask.LayerToName(vol.gameObject.layer)
            + " profile=" + (vol.sharedProfile == null ? "NULL" : AssetDatabase.GetAssetPath(vol.sharedProfile))));
        return sb.ToString();
    }

    static string Prop(VolumeProfile p)
    {
        Tonemapping t; Bloom b;
        var sb = new StringBuilder("  ->");
        if (p.TryGet(out t)) sb.Append(" tone=" + t.mode.value);
        if (p.TryGet(out b)) sb.Append(" bloom=" + b.threshold.value + "/" + b.intensity.value
            + " hq=" + b.highQualityFiltering.value + " filter=" + b.filter.value
            + " down=" + b.downscale.value + " iter=" + b.maxIterations.value);
        return sb.ToString();
    }

    // ===================================================== helpers

    static Volume FindVolume()
    {
        foreach (var scn in AllScenes())
            foreach (var r in scn.GetRootGameObjects())
                foreach (var v in r.GetComponentsInChildren<Volume>(true))
                    if (v.gameObject.name == VolumeName) return v;
        return null;
    }

    static GameObject FindRoot(string name)
    {
        foreach (var scn in AllScenes())
            foreach (var r in scn.GetRootGameObjects())
                if (r.name == name) return r;
        return null;
    }

    static System.Collections.Generic.List<Scene> AllScenes()
    {
        var list = new System.Collections.Generic.List<Scene>();
        for (int i = 0; i < SceneManager.sceneCount; i++) list.Add(SceneManager.GetSceneAt(i));
        return list;
    }

    static string PathOf(Transform t)
    {
        var s = t.name;
        while (t.parent != null) { t = t.parent; s = t.name + "/" + s; }
        return s;
    }

    static string Err(Exception e)
    {
        var s = "EXCEPTION " + e.GetType().Name + ": " + e.Message;
        return s.Length > 900 ? s.Substring(0, 900) : s;
    }
}
