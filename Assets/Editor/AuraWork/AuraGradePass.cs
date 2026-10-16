using System;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.SceneManagement;

public static class AuraGradePass
{
    const string ProfilePath = "Assets/Settings/DefaultVolumeProfile.asset";
    const string ProfileGuid = "ab09877e2e707104187f6f83e2f62510";
    const string RpAssetPath = "Assets/Settings/PC_RPAsset.asset";
    const string UnderwaterProfile = "Assets/Settings/Underwater_VolumeProfile.asset";

    static readonly Vector3 REF_POS = new Vector3(715.32580f, 11.52654f, 222.06380f);

    // ---------------------------------------------------------------- refs

    public static string Refs()
    {
        var sb = new StringBuilder();

        // who references the profile guid (text scan: cheap + exhaustive for small folders)
        var roots = new[] { "Assets/Settings", "Assets/Enviornment_Scene", "ProjectSettings", "Assets" };
        var seen = new System.Collections.Generic.HashSet<string>();
        foreach (var root in roots)
        {
            if (!System.IO.Directory.Exists(root)) continue;
            foreach (var f in System.IO.Directory.GetFiles(root, "*.*", System.IO.SearchOption.AllDirectories))
            {
                var ext = System.IO.Path.GetExtension(f).ToLowerInvariant();
                if (ext != ".asset" && ext != ".unity" && ext != ".json" && ext != ".txt" && ext != ".preset" && ext != ".settings") continue;
                var full = System.IO.Path.GetFullPath(f);
                if (!seen.Add(full)) continue;
                string txt;
                try { txt = System.IO.File.ReadAllText(f); } catch { continue; }
                if (txt.Contains(ProfileGuid)) sb.AppendLine("GUID-REF " + f.Replace('\\', '/') + "  (" + txt.Length + " chars)");
            }
        }

        // pipeline global settings asset + its object references
        foreach (var g in AssetDatabase.FindAssets("t:UniversalRenderPipelineGlobalSettings", new[] { "Assets" }))
        {
            var p = AssetDatabase.GUIDToAssetPath(g);
            sb.AppendLine("GLOBALSETTINGS " + p);
            var gs = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(p);
            var so = new SerializedObject(gs);
            var it = so.GetIterator();
            bool enter = it.NextVisible(true);
            while (enter)
            {
                if (it.propertyType == SerializedPropertyType.ObjectReference && it.objectReferenceValue != null)
                    sb.AppendLine("   " + it.propertyPath + " -> " + AssetDatabase.GetAssetPath(it.objectReferenceValue));
                enter = it.NextVisible(true);
            }
        }

        // does the RP asset carry a default volume profile?
        var rp = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(RpAssetPath);
        if (rp != null)
        {
            var so = new SerializedObject(rp);
            var it = so.GetIterator();
            bool enter = it.NextVisible(true);
            while (enter)
            {
                if (it.propertyType == SerializedPropertyType.ObjectReference && it.objectReferenceValue != null)
                    sb.AppendLine("RP " + it.propertyPath + " -> " + AssetDatabase.GetAssetPath(it.objectReferenceValue));
                enter = it.NextVisible(true);
            }
        }

        // the local volume: geometry vs the pinned camera position
        foreach (var scn in AllScenes())
            foreach (var r in scn.GetRootGameObjects())
                foreach (var v in r.GetComponentsInChildren<Volume>(true))
                {
                    sb.AppendLine("VOLUME " + PathOf(v.transform) + " global=" + v.isGlobal + " prio=" + v.priority);
                    foreach (var col in v.GetComponents<Collider>())
                    {
                        var b = col.bounds;
                        sb.AppendLine("   collider=" + col.GetType().Name + " center=" + b.center + " size=" + b.size
                            + " camInside=" + b.Contains(REF_POS));
                    }
                    foreach (var col in v.GetComponentsInChildren<Collider>())
                    {
                        if (col.transform == v.transform) continue;
                        var b = col.bounds;
                        sb.AppendLine("   childCollider=" + PathOf(col.transform) + " center=" + b.center + " size=" + b.size
                            + " camInside=" + b.Contains(REF_POS));
                    }
                }

        sb.AppendLine(DumpGrade(UnderwaterProfile));
        return sb.ToString();
    }

    // ---------------------------------------------------------------- profile dump

    public static string DumpGrade(string path)
    {
        var vp = AssetDatabase.LoadAssetAtPath<VolumeProfile>(path);
        if (vp == null) return "PROFILE " + path + " (not a VolumeProfile)";
        var sb = new StringBuilder();
        sb.AppendLine("PROFILE " + path + " components=" + vp.components.Count);
        var list = new StringBuilder("    ");
        foreach (var c in vp.components) list.Append(c == null ? "<null> " : c.GetType().Name + " ");
        sb.AppendLine(list.ToString());

        Tonemapping t; Bloom b; ColorAdjustments ca;
        if (vp.TryGet(out t)) sb.AppendLine("  Tone mode=" + t.mode.value + "[o=" + t.mode.overrideState + "] active=" + t.active
            + " neutral=" + t.neutralHDRRangeReductionMode.value + " aces=" + t.acesPreset.value);
        if (vp.TryGet(out b)) sb.AppendLine("  Bloom thr=" + b.threshold.value + "[o=" + b.threshold.overrideState + "]"
            + " int=" + b.intensity.value + "[o=" + b.intensity.overrideState + "]"
            + " scatter=" + b.scatter.value + "[o=" + b.scatter.overrideState + "]"
            + " clamp=" + b.clamp.value + "[o=" + b.clamp.overrideState + "]"
            + " tint=" + b.tint.value + "[o=" + b.tint.overrideState + "]"
            + " hq=" + b.highQualityFiltering.value + "[" + b.highQualityFiltering.overrideState + "]"
            + " filter=" + b.filter.value + "[" + b.filter.overrideState + "]"
            + " downscale=" + b.downscale.value + "[" + b.downscale.overrideState + "]"
            + " maxIter=" + b.maxIterations.value + "[" + b.maxIterations.overrideState + "]"
            + " dirt=" + b.dirtIntensity.value + "[" + b.dirtIntensity.overrideState + "] active=" + b.active);
        if (vp.TryGet(out ca)) sb.AppendLine("  ColorAdj post=" + ca.postExposure.value + " contrast=" + ca.contrast.value
            + " filter=" + ca.colorFilter.value + " hue=" + ca.hueShift.value + " sat=" + ca.saturation.value);
        return sb.ToString();
    }

    public static string DumpAll()
    {
        var sb = new StringBuilder();
        sb.AppendLine(DumpGrade(ProfilePath));
        sb.AppendLine(DumpGrade(UnderwaterProfile));
        return sb.ToString();
    }

    // ---------------------------------------------------------------- probe

    public static string Probe()
    {
        var sb = new StringBuilder();

        foreach (var scn in AllScenes())
            foreach (var r in scn.GetRootGameObjects())
                foreach (var v in r.GetComponentsInChildren<Volume>(true))
                {
                    var prof = v.sharedProfile;
                    sb.AppendLine("VOLUME scene=" + scn.name + " path=" + PathOf(v.transform)
                        + " enabled=" + v.enabled + " global=" + v.isGlobal + " prio=" + v.priority + " weight=" + v.weight
                        + " layer=" + LayerMask.LayerToName(v.gameObject.layer)
                        + " sharedProfile=" + (prof == null ? "NULL" : AssetDatabase.GetAssetPath(prof))
                        + " instancedProfile=" + (v.profile == null ? "NULL" : AssetDatabase.GetAssetPath(v.profile)));
                }

        var cam = Camera.main;
        if (cam == null) sb.AppendLine("NO MAIN CAMERA");
        else
        {
            var add = cam.GetUniversalAdditionalCameraData();
            sb.AppendLine("CAM " + PathOf(cam.transform)
                + " post=" + (add != null ? add.renderPostProcessing.ToString() : "NO-ADDITIONAL-DATA")
                + " hdr=" + cam.allowHDR + " msaa=" + cam.allowMSAA
                + " camType=" + cam.cameraType
                + " renderType=" + (add != null ? add.renderType.ToString() : "?")
                + " volumeMask=" + (add != null ? add.volumeLayerMask.value.ToString() : "?")
                + " trigger=" + (add != null && add.volumeTrigger != null ? PathOf(add.volumeTrigger) : "null(self)")
                + " targetTexture=" + (cam.targetTexture == null ? "NULL(screen)" : cam.targetTexture.name)
                + " targetDisplay=" + cam.targetDisplay);
        }

        var rp = GraphicsSettings.currentRenderPipeline;
        sb.AppendLine("RPASSET " + (rp == null ? "NULL(Built-in)" : rp.GetType().Name + " " + AssetDatabase.GetAssetPath(rp)));
        if (rp != null)
        {
            var rpSo = new SerializedObject(rp);
            sb.AppendLine("  colorGradingMode=" + EnumName<ColorGradingMode>(rpSo, "m_ColorGradingMode")
                + " lutSize=" + rpSo.FindProperty("m_ColorGradingLutSize").intValue
                + " supportsHDR=" + rpSo.FindProperty("m_SupportsHDR").boolValue
                + " msaa=" + EnumName<MsaaQuality>(rpSo, "m_MSAA")
                + " hdrPrecision=" + rpSo.FindProperty("m_HDRColorBufferPrecision").intValue);
        }

        sb.AppendLine("STACK " + StackLine());
        sb.AppendLine("CLOCK " + ClockLine());
        return sb.ToString();
    }

    public static string StackLine()
    {
        var stack = VolumeManager.instance == null ? null : VolumeManager.instance.stack;
        if (stack == null) return "null (no active volume stack)";
        var sb = new StringBuilder();
        var t = stack.GetComponent<Tonemapping>();
        var b = stack.GetComponent<Bloom>();
        if (t != null) sb.Append("Tone mode=" + t.mode.value + "[o=" + t.mode.overrideState + "] active=" + t.active + " | ");
        if (b != null) sb.Append("Bloom thr=" + b.threshold.value + "[o=" + b.threshold.overrideState + "]"
            + " int=" + b.intensity.value + "[o=" + b.intensity.overrideState + "]"
            + " scatter=" + b.scatter.value + " clamp=" + b.clamp.value
            + " tint=" + b.tint.value + " hq=" + b.highQualityFiltering.value + " filter=" + b.filter.value
            + " downscale=" + b.downscale.value + " maxIter=" + b.maxIterations.value + " active=" + b.active);
        return sb.ToString();
    }

    public static string ClockLine()
    {
        var w = CozyFind();
        if (w == null) return "no cozyweather";
        var tm = w.timeModule;
        if (tm == null) return "no time module";
        var f = tm.GetType().GetField("perennialProfile", BindingFlags.Public | BindingFlags.Instance);
        object pp = f == null ? null : f.GetValue(tm);
        var pause = pp == null ? null : pp.GetType().GetField("pauseTime", BindingFlags.Public | BindingFlags.Instance);
        var speed = pp == null ? null : pp.GetType().GetField("timeMovementSpeed", BindingFlags.Public | BindingFlags.Instance);
        return "currentTime=" + ((float)tm.currentTime).ToString("R")
            + " modifiedDay%=" + w.modifiedDayPercentage.ToString("R")
            + " pauseTime=" + (pause == null ? "?" : pause.GetValue(pp).ToString())
            + " timeMovementSpeed=" + (speed == null ? "?" : speed.GetValue(pp).ToString());
    }

    static string EnumName<T>(SerializedObject so, string prop) where T : struct
    {
        var p = so.FindProperty(prop);
        if (p == null) return "?";
        T v;
        try { v = (T)Enum.ToObject(typeof(T), p.enumValueIndex); } catch { return p.enumValueIndex.ToString(); }
        return v.ToString();
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

    static DistantLands.Cozy.CozyWeather CozyFind()
    {
        foreach (var scn in AllScenes())
            foreach (var r in scn.GetRootGameObjects())
                foreach (var c in r.GetComponentsInChildren<Component>(true))
                {
                    var w = c as DistantLands.Cozy.CozyWeather;
                    if (w != null) return w;
                }
        return null;
    }

    public static string Execute()
    {
        try { return Probe(); }
        catch (Exception e) { return Err(e); }
    }

    public static string R()
    {
        try { return Refs(); }
        catch (Exception e) { return Err(e); }
    }

    public static string D()
    {
        try { return DumpAll(); }
        catch (Exception e) { return Err(e); }
    }

    static string Err(Exception e)
    {
        var s = "EXCEPTION " + e.GetType().Name + ": " + e.Message + "\n" + e.StackTrace;
        return s.Length > 1800 ? s.Substring(0, 1800) : s;
    }
}
