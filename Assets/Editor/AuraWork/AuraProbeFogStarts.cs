using System.Text;
using UnityEngine;

public static class AuraProbeFogStarts
{
    public static string Execute()
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("isPlaying = " + Application.isPlaying);
        sb.AppendLine("CZY_FogColorStart1 = " + Shader.GetGlobalFloat("CZY_FogColorStart1").ToString("F4"));
        sb.AppendLine("CZY_FogColorStart2 = " + Shader.GetGlobalFloat("CZY_FogColorStart2").ToString("F4"));
        sb.AppendLine("CZY_FogColorStart3 = " + Shader.GetGlobalFloat("CZY_FogColorStart3").ToString("F4"));
        sb.AppendLine("CZY_FogColorStart4 = " + Shader.GetGlobalFloat("CZY_FogColorStart4").ToString("F4"));
        sb.AppendLine("CZY_FogDepthMultiplier = " + Shader.GetGlobalFloat("CZY_FogDepthMultiplier").ToString("F4"));
        return sb.ToString();
    }
}
