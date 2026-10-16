using System.Collections.Generic;
using System.Text;
using DistantLands.Cozy;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

public static class AuraLightProbe
{
    const string ProfilePath = "Assets/Settings/LuminousLake_Atmosphere.asset";

    static readonly Vector3 REF_POS = new Vector3(715.32580f, 11.52654f, 222.06380f);
    static readonly Vector3 REF_EULER = new Vector3(359.69170f, 357.66090f, 0.00025f);

    static CozyWeather CW()
    {
        var scene = SceneManager.GetActiveScene();
        foreach (var r in scene.GetRootGameObjects())
            foreach (var c in r.GetComponentsInChildren<Component>(true))
                if (c is CozyWeather w) return w;
        return null;
    }

    static CozyTimeModule TM()
    {
        var scene = SceneManager.GetActiveScene();
        foreach (var r in scene.GetRootGameObjects())
            foreach (var c in r.GetComponentsInChildren<Component>(true))
                if (c is CozyTimeModule t) return t;
        return null;
    }

    static string F(Color c) { return "(" + c.r.ToString("F4") + "," + c.g.ToString("F4") + "," + c.b.ToString("F4") + "," + c.a.ToString("F4") + ")"; }

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
        return "PIN disabled=" + disabled + " pos=" + t.position.ToString("F4") + " euler=" + t.eulerAngles.ToString("F4");
    }

    public static string Probe()
    {
        var sb = new StringBuilder();
        var w = CW();
        var tm = TM();

        // ---- camera ----
        var cam = Camera.main;
        if (cam != null)
        {
            var t = cam.transform;
            sb.AppendLine("CAM pos=" + t.position.ToString("F4") + " euler=" + t.eulerAngles.ToString("F4")
                + " fov=" + cam.fieldOfView + " far=" + cam.farClipPlane + " drift=" + (t.position - REF_POS).magnitude.ToString("F4"));
            var uacd = cam.GetComponent<UnityEngine.Rendering.Universal.UniversalAdditionalCameraData>();
            if (uacd != null)
                sb.AppendLine("CAM UACD post=" + uacd.renderPostProcessing
                    + " hdr=" + cam.allowHDR + " msaa=" + cam.allowMSAA);
        }

        if (tm != null)
            sb.AppendLine("TIME currentTime=" + ((float)tm.currentTime).ToString("R")
                + " modifiedDay%=" + tm.modifiedDayPercentage.ToString("R"));

        if (w != null)
        {
            sb.AppendLine("handleSceneLighting=" + w.handleSceneLighting + " fogStyle=" + w.fogStyle);
            sb.AppendLine("sunlightColor=" + F(w.sunlightColor) + "  (luma=" + Lum(w.sunlightColor).ToString("F4") + ")");
            sb.AppendLine("sunFilter=" + F(w.sunFilter) + " filterColor=" + F(w.filterColor)
                + " filterSat=" + w.filterSaturation.ToString("R") + " filterVal=" + w.filterValue.ToString("R"));
            sb.AppendLine("ambientZenith=" + F(w.ambientLightZenithColor) + "  (luma=" + Lum(w.ambientLightZenithColor).ToString("F4") + ")");
            sb.AppendLine("ambientHorizon=" + F(w.ambientLightHorizonColor));
            sb.AppendLine("ambientLightMultiplier=" + w.ambientLightMultiplier.ToString("R"));
            sb.AppendLine("cumulus=" + w.cumulus.ToString("R") + " cloudColor=" + F(w.cloudColor));
            sb.AppendLine("skyZenith=" + F(w.skyZenithColor) + " skyHorizon=" + F(w.skyHorizonColor));

            if (w.sunLight != null)
            {
                sb.AppendLine("SUN LIGHT name='" + w.sunLight.gameObject.name + "' intensity=" + w.sunLight.intensity.ToString("R")
                    + " color=" + F(w.sunLight.color) + " luma=" + Lum(w.sunLight.color).ToString("F4")
                    + " enabled=" + w.sunLight.enabled + " shadows=" + w.sunLight.shadows
                    + " type=" + w.sunLight.type + " lightmapBake=" + w.sunLight.lightmapBakeType
                    + " indirectMultiplier=" + w.sunLight.bounceIntensity.ToString("R"));
                sb.AppendLine("SUN xform euler=" + w.sunLight.transform.eulerAngles.ToString("F3"));
            }
            else sb.AppendLine("SUN LIGHT = NULL");
        }
        else sb.AppendLine("CozyWeather = NULL");

        sb.AppendLine("RenderSettings ambientMode=" + RenderSettings.ambientMode
            + " intensity=" + RenderSettings.ambientIntensity.ToString("R"));
        sb.AppendLine("  ambientSky=" + F(RenderSettings.ambientSkyColor)
            + " luma=" + Lum(RenderSettings.ambientSkyColor).ToString("F4"));
        sb.AppendLine("  ambientEquator=" + F(RenderSettings.ambientEquatorColor)
            + " luma=" + Lum(RenderSettings.ambientEquatorColor).ToString("F4"));
        sb.AppendLine("  ambientGround=" + F(RenderSettings.ambientGroundColor)
            + " luma=" + Lum(RenderSettings.ambientGroundColor).ToString("F4"));
        sb.AppendLine("  ambientLight(skybox) luma=" + Lum(RenderSettings.ambientLight).ToString("F4")
            + " sun=" + (RenderSettings.sun == null ? "NULL" : RenderSettings.sun.name));

        // ---- all lights in scene ----
        var scene = SceneManager.GetActiveScene();
        int dir = 0;
        foreach (var r in scene.GetRootGameObjects())
            foreach (var l in r.GetComponentsInChildren<Light>(true))
            {
                if (l.type == LightType.Directional)
                {
                    dir++;
                    sb.AppendLine("DIRLIGHT '" + l.gameObject.name + "' intensity=" + l.intensity.ToString("R")
                        + " colorLuma=" + Lum(l.color).ToString("F4") + " enabled=" + l.enabled);
                }
            }
        sb.AppendLine("directionalLightCount=" + dir);

        // ---- grading (report only) ----
        var vol = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>("Assets/Settings/DefaultVolumeProfile.asset");
        if (vol != null)
        {
            var so = new SerializedObject(vol);
            var comps = so.FindProperty("components");
            if (comps != null)
            {
                for (int i = 0; i < comps.arraySize; i++)
                {
                    var e = comps.GetArrayElementAtIndex(i);
                    var o = e.objectReferenceValue;
                    if (o == null) continue;
                    var n = o.GetType().Name;
                    if (n == "Tonemapping" || n == "ColorAdjustments" || n == "Bloom" || n == "Exposure")
                    {
                        var cso = new SerializedObject(o);
                        var it = cso.GetIterator();
                        var inner = new StringBuilder();
                        int guard = 0;
                        while (it.NextVisible(true) && guard++ < 60)
                        {
                            if (it.propertyType == SerializedPropertyType.Float)
                                inner.Append(" " + it.name + "=" + it.floatValue.ToString("F3"));
                            else if (it.propertyType == SerializedPropertyType.Integer)
                                inner.Append(" " + it.name + "=" + it.intValue);
                            else if (it.propertyType == SerializedPropertyType.Boolean && it.name.StartsWith("m_Override"))
                                inner.Append(" " + it.name + "=" + it.boolValue);
                            else if (it.propertyType == SerializedPropertyType.Color)
                                inner.Append(" " + it.name + "=" + F(it.colorValue));
                        }
                        sb.AppendLine("VOLUME " + n + ":" + inner);
                    }
                }
            }
        }
        return sb.ToString();
    }

    static float Lum(Color c) { return 0.2126f * c.r + 0.7152f * c.g + 0.0722f * c.b; }

    public static string Execute() { return Pin() + "\n" + Probe(); }
}
