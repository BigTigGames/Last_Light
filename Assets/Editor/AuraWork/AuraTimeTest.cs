using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class AuraTimeTest
{
    // authored clock recorded at the start of the daylight pass
    const float ORIG_TIME = 0.3884804f;

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

    static string Clock(DistantLands.Cozy.CozyWeather w)
    {
        float t = w.timeModule.currentTime;
        int mins = Mathf.FloorToInt(t * 1440f);
        var sb = new StringBuilder();
        sb.AppendLine("CLOCK currentTime=" + t.ToString("R")
            + " (" + (mins / 60).ToString("00") + ":" + (mins % 60).ToString("00") + ")"
            + " modifiedDay%=" + w.modifiedDayPercentage.ToString("R")
            + " day%=" + w.dayPercentage.ToString("R"));
        return sb.ToString();
    }

    static string Set(int hour, int minute)
    {
        var w = Find();
        if (w == null) return "NO COZYWEATHER";
        w.timeModule.SetHour(hour);
        w.timeModule.SetMinute(minute);
        return "SET " + hour.ToString("00") + ":" + minute.ToString("00") + "\n" + Clock(w);
    }

    public static string State() { var w = Find(); return w == null ? "NO COZYWEATHER" : Clock(w); }

    public static string Dusk() { return Set(19, 0); }
    public static string Night() { return Set(23, 0); }
    public static string Dawn() { return Set(6, 30); }

    public static string Restore()
    {
        var w = Find();
        if (w == null) return "NO COZYWEATHER";
        w.timeModule.currentTime = ORIG_TIME;   // implicit float -> MeridiemTime
        var sb = new StringBuilder();
        sb.AppendLine("RESTORED to " + ORIG_TIME.ToString("R"));
        sb.AppendLine(Clock(w));
        sb.AppendLine(AuraLightPass.Live());
        return sb.ToString();
    }

    public static string Execute()
    {
        var w = Find();
        if (w == null) return "NO COZYWEATHER";
        var sb = new StringBuilder();
        sb.AppendLine(Clock(w));
        sb.AppendLine(AuraLightPass.Live());
        return sb.ToString();
    }
}
