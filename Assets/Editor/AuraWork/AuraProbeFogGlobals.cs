using System;
using System.Reflection;
using System.Text;
using UnityEngine;

public static class AuraProbeFogGlobals
{
    static string Col(Color c)
    {
        return "(" + c.r.ToString("F4") + ", " + c.g.ToString("F4") + ", " + c.b.ToString("F4") + ", " + c.a.ToString("F4") + ")";
    }

    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();

        sb.AppendLine("=== SHADER GLOBALS (what the COZY fog shader actually receives) ===");
        sb.AppendLine("isPlaying              = " + Application.isPlaying);
        sb.AppendLine("CZY_DayPercentage      = " + Shader.GetGlobalFloat("CZY_DayPercentage").ToString("F4"));
        sb.AppendLine("CZY_FogDepthMultiplier = " + Shader.GetGlobalFloat("CZY_FogDepthMultiplier").ToString("F4"));
        for (int i = 1; i <= 5; i++)
        {
            sb.AppendLine("CZY_FogColor" + i + "          = " + Col(Shader.GetGlobalColor("CZY_FogColor" + i)));
        }

        sb.AppendLine();
        sb.AppendLine("=== Live CozyWeather ===");

        Type t = null;
        foreach (Assembly a in AppDomain.CurrentDomain.GetAssemblies())
        {
            try { t = a.GetType("DistantLands.Cozy.CozyWeather", false); } catch { }
            if (t != null) break;
        }
        if (t == null)
        {
            sb.AppendLine("CozyWeather type not found");
            return sb.ToString();
        }

        UnityEngine.Object[] all = Resources.FindObjectsOfTypeAll(t);
        sb.AppendLine("CozyWeather instances = " + all.Length);

        for (int k = 0; k < all.Length; k++)
        {
            Component c = all[k] as Component;
            if (c == null) continue;
            sb.AppendLine("--- scene=" + c.gameObject.scene.name + " obj=" + c.gameObject.name + " ---");

            string[] props = new string[] { "dayPercentage", "modifiedDayPercentage", "yearPercentage" };
            for (int i = 0; i < props.Length; i++)
            {
                PropertyInfo p = t.GetProperty(props[i], BindingFlags.Public | BindingFlags.Instance);
                if (p != null && p.PropertyType == typeof(float))
                {
                    sb.AppendLine(props[i] + " = " + Convert.ToSingle(p.GetValue(all[k], null)).ToString("F4"));
                }
            }

            string[] fields = new string[] { "fogColor1", "fogColor2", "fogColor3", "fogColor4", "fogColor5",
                                             "fogDensityMultiplier", "fogDensity", "gradientExponent",
                                             "usePhysicalSunHeight", "SceneFogRendering" };
            for (int i = 0; i < fields.Length; i++)
            {
                FieldInfo f = t.GetField(fields[i], BindingFlags.Public | BindingFlags.Instance);
                if (f == null) continue;
                object v = f.GetValue(all[k]);
                if (v is Color)
                {
                    sb.AppendLine(fields[i] + " = " + Col((Color)v));
                }
                else
                {
                    sb.AppendLine(fields[i] + " = " + (v == null ? "null" : v.ToString()));
                }
            }

            FieldInfo atmField = t.GetField("atmosphere", BindingFlags.Public | BindingFlags.Instance);
            if (atmField != null)
            {
                object atm = atmField.GetValue(all[k]);
                if (atm != null)
                {
                    FieldInfo pf = atm.GetType().GetField("atmosphereProfile",
                        BindingFlags.Public | BindingFlags.Instance | BindingFlags.NonPublic);
                    object prof = pf != null ? pf.GetValue(atm) : null;
                    UnityEngine.Object profObj = prof as UnityEngine.Object;
                    sb.AppendLine("atmosphere.atmosphereProfile = " + (profObj != null ? profObj.name : "null"));
                }
            }

            FieldInfo tmField = t.GetField("timeModule", BindingFlags.Public | BindingFlags.Instance);
            if (tmField != null)
            {
                object tm = tmField.GetValue(all[k]);
                if (tm != null)
                {
                    Type tt = tm.GetType();
                    string[] tprops = new string[] { "currentTime", "currentDayPercentage", "modifiedDayPercentage" };
                    for (int i = 0; i < tprops.Length; i++)
                    {
                        PropertyInfo p = tt.GetProperty(tprops[i], BindingFlags.Public | BindingFlags.Instance);
                        if (p != null && p.PropertyType == typeof(float))
                        {
                            sb.AppendLine("timeModule." + tprops[i] + " = " + Convert.ToSingle(p.GetValue(tm, null)).ToString("F4"));
                        }
                    }
                    string[] tfields = new string[] { "currentTime", "currentDayPercentage", "modifiedDayPercentage",
                                                      "currentHour", "currentMinute", "currentSecond" };
                    for (int i = 0; i < tfields.Length; i++)
                    {
                        FieldInfo f = tt.GetField(tfields[i], BindingFlags.Public | BindingFlags.Instance);
                        if (f != null)
                        {
                            object v = f.GetValue(tm);
                            sb.AppendLine("timeModule." + tfields[i] + " = " + (v == null ? "null" : v.ToString()));
                        }
                    }
                }
            }
        }

        return sb.ToString();
    }
}
