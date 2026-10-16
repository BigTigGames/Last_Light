using System.Text;
using UnityEngine;

public static class AuraFrameStats
{
    static readonly Vector3 REF_POS = new Vector3(715.32580f, 11.52654f, 222.06380f);
    static readonly Vector3 REF_EULER = new Vector3(359.69170f, 357.66090f, 0.00025f);

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

    public static string Capture()
    {
        var cam = Camera.main;
        if (cam == null) return "NO MAIN CAMERA";

        int W = 320, H = 240;
        var rt = RenderTexture.GetTemporary(W, H, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        var prev = cam.targetTexture;
        cam.targetTexture = rt;
        cam.Render();
        cam.targetTexture = prev;

        var prevActive = RenderTexture.active;
        RenderTexture.active = rt;
        var tex = new Texture2D(W, H, TextureFormat.RGBA32, false, true);
        tex.ReadPixels(new Rect(0, 0, W, H), 0, 0);
        tex.Apply();
        RenderTexture.active = prevActive;
        RenderTexture.ReleaseTemporary(rt);

        var raw = tex.GetPixels();
        Object.DestroyImmediate(tex);

        // flip rows so index 0 is TOP-LEFT and row order matches the picture
        var px = new Color[raw.Length];
        for (int y = 0; y < H; y++)
            for (int x = 0; x < W; x++)
                px[(H - 1 - y) * W + x] = raw[y * W + x];

        var sb = new StringBuilder();
        sb.AppendLine("FRAME " + W + "x" + H + "  (display-referred 0-1)");

        // ---- global ----
        double r = 0, g = 0, b = 0, lum = 0, lum2 = 0;
        int n = px.Length, over90 = 0, over95 = 0, over99 = 0, under10 = 0;
        int[] hist = new int[16];
        for (int i = 0; i < n; i++)
        {
            var c = px[i];
            r += c.r; g += c.g; b += c.b;
            float l = Lum(c);
            lum += l; lum2 += (double)l * l;
            if (l > 0.90f) over90++;
            if (l > 0.95f) over95++;
            if (l > 0.99f) over99++;
            if (l < 0.10f) under10++;
            hist[Mathf.Clamp((int)(l * 16f), 0, 15)]++;
        }
        double mean = lum / n;
        double sd = System.Math.Sqrt(lum2 / n - mean * mean);
        sb.AppendLine("MEAN rgb=(" + (r / n).ToString("F4") + "," + (g / n).ToString("F4") + "," + (b / n).ToString("F4")
            + ") luma=" + mean.ToString("F4") + " sd=" + sd.ToString("F4"));
        sb.AppendLine("CLIP% >0.90=" + (100.0 * over90 / n).ToString("F2")
            + " >0.95=" + (100.0 * over95 / n).ToString("F2")
            + " >0.99=" + (100.0 * over99 / n).ToString("F2")
            + "  BLACK% <0.10=" + (100.0 * under10 / n).ToString("F2"));

        var h = new StringBuilder("HIST16 ");
        for (int i = 0; i < 16; i++) h.Append((100.0 * hist[i] / n).ToString("0.0")).Append(" ");
        sb.AppendLine(h.ToString());

        // ---- 8x6 grid: mean luma / stddev ----
        int GX = 8, GY = 6;
        sb.AppendLine("GRID " + GX + "x" + GY + " mean/sd (row 0 = TOP):");
        for (int gy = 0; gy < GY; gy++)
        {
            var row = new StringBuilder("  ");
            for (int gx = 0; gx < GX; gx++)
            {
                int x0 = gx * W / GX, x1 = (gx + 1) * W / GX;
                int y0 = gy * H / GY, y1 = (gy + 1) * H / GY;
                double s = 0, s2 = 0; int c2 = 0, clip = 0;
                for (int y = y0; y < y1; y++)
                    for (int x = x0; x < x1; x++)
                    {
                        float l = Lum(px[y * W + x]);
                        s += l; s2 += (double)l * l; c2++;
                        if (l > 0.95f) clip++;
                    }
                double m = s / c2;
                double d = System.Math.Sqrt(s2 / c2 - m * m);
                row.Append(m.ToString("0.00")).Append("/").Append(d.ToString("0.00")).Append(" ").Append((100 * clip / c2).ToString("00")).Append("%  ");
            }
            sb.AppendLine(row.ToString());
        }

        // ---- named bands (normalised x0,x1,y0,y1 with y0 at TOP) ----
        sb.AppendLine("REGIONS (x0,x1,y0,y1 top-origin): mean rgb | luma | sd | clip%");
        Reg(sb, px, W, H, "bottom_strip", 0.00f, 1.00f, 0.78f, 1.00f);
        Reg(sb, px, W, H, "top_strip   ", 0.00f, 1.00f, 0.00f, 0.22f);
        Reg(sb, px, W, H, "mid_strip   ", 0.00f, 1.00f, 0.40f, 0.62f);
        Reg(sb, px, W, H, "bot_right   ", 0.55f, 1.00f, 0.80f, 1.00f);
        Reg(sb, px, W, H, "bot_left    ", 0.00f, 0.30f, 0.78f, 1.00f);
        Reg(sb, px, W, H, "bot_centre  ", 0.30f, 0.55f, 0.78f, 1.00f);
        Reg(sb, px, W, H, "horizon_sky ", 0.00f, 1.00f, 0.05f, 0.35f);

        return sb.ToString();
    }

    static void Reg(StringBuilder sb, Color[] px, int W, int H, string name, float fx0, float fx1, float fy0, float fy1)
    {
        int x0 = Mathf.Clamp((int)(fx0 * W), 0, W - 1), x1 = Mathf.Clamp((int)(fx1 * W), 1, W);
        int y0 = Mathf.Clamp((int)(fy0 * H), 0, H - 1), y1 = Mathf.Clamp((int)(fy1 * H), 1, H);
        double r = 0, g = 0, b = 0, l = 0, l2 = 0; int c = 0, clip = 0;
        for (int y = y0; y < y1; y++)
            for (int x = x0; x < x1; x++)
            {
                var col = px[y * W + x];
                r += col.r; g += col.g; b += col.b;
                float ll = Lum(col);
                l += ll; l2 += (double)ll * ll; c++;
                if (ll > 0.95f) clip++;
            }
        double m = l / c;
        double sd = System.Math.Sqrt(l2 / c - m * m);
        sb.AppendLine("  " + name + " rgb=(" + (r / c).ToString("F3") + "," + (g / c).ToString("F3") + "," + (b / c).ToString("F3")
            + ") luma=" + m.ToString("F3") + " sd=" + sd.ToString("F3") + " clip%=" + (100.0 * clip / c).ToString("F1"));
    }

    static float Lum(Color c) { return 0.2126f * c.r + 0.7152f * c.g + 0.0722f * c.b; }

    public static string Execute() { return Pin() + "\n" + Capture(); }
}
