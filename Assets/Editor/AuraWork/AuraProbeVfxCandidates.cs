using System;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace AuraWork
{
    public static class AuraProbeVfxCandidates
    {
        private static readonly string[] Paths = new[]
        {
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_BlowingLeaves_01.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_BlowingLeaves_02.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_Dust_01.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_Dust_02.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_LootSparkle_01.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_Mist_01.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Worlds - Forest/Particles/VFX_FW01_WindTrails.prefab",
            "Assets/Third_Party_assets/Stylized Water 3/Prefabs/Particles/WaterRipples_Stationairy.prefab",
            "Assets/Third_Party_assets/Stylized Water 3/Prefabs/Particles/WaterSplash_Impact.prefab",
            "Assets/Third_Party_assets/Stylized Water 3/Prefabs/Particles/BigSplash.prefab",
            "Assets/Third_Party_assets/Daniel Mistage/STYLIZED Fantasy Village - Low Poly 3D Art/Prefabs/VFX/Wind_Effect_1.prefab",
            "Assets/Third_Party_assets/Daniel Mistage/STYLIZED Fantasy Village - Low Poly 3D Art/Prefabs/VFX/Falling_Leaves.prefab",
            "Assets/Third_Party_assets/Polyart/PolyartStudio/SharedResources/Effects/P_Dust_Wind.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Forest Environment/Particle Effects/PS_FFE_Dust.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Forest Environment/Particle Effects/PS_FFE_Falling_Leaves.prefab",
            "Assets/Third_Party_assets/TriForge Assets/Fantasy Forest Environment/Particle Effects/PS_FFE_Watersplash.prefab"
        };

        public static string Execute()
        {
            var sb = new StringBuilder();
            sb.AppendLine("=== PARTICLE PREFAB PROFILES ===");
            foreach (var path in Paths)
            {
                var go = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                if (go == null) { sb.AppendLine("MISSING : " + path); continue; }

                var ps = go.GetComponentInChildren<ParticleSystem>(true);
                sb.AppendLine("--- " + System.IO.Path.GetFileNameWithoutExtension(path));

                if (ps == null) { sb.AppendLine("    no ParticleSystem; renderer children=" + go.GetComponentsInChildren<Renderer>(true).Length); continue; }

                var main = ps.main;
                sb.AppendLine("    loop=" + main.loop + " playOnAwake=" + main.playOnAwake +
                              " duration=" + main.duration.ToString("F1") +
                              " maxParticles=" + main.maxParticles +
                              " space=" + main.simulationSpace);
                sb.AppendLine("    lifetime=" + main.startLifetime.constantMin.ToString("F1") + ".." + main.startLifetime.constantMax.ToString("F1") +
                              " speed=" + main.startSpeed.constantMin.ToString("F1") + ".." + main.startSpeed.constantMax.ToString("F1") +
                              " size=" + main.startSize.constantMin.ToString("F2") + ".." + main.startSize.constantMax.ToString("F2") +
                              " gravity=" + main.gravityModifier.constant.ToString("F2"));
                var em = ps.emission;
                sb.AppendLine("    emitRate=" + em.rateOverTime.constant + " enabled=" + em.enabled +
                              " bursts=" + em.burstCount + " rateOverDist=" + em.rateOverDistance.constant);
                var sh = ps.shape;
                sb.AppendLine("    shape=" + sh.shapeType + " radius=" + sh.radius + " angle=" + sh.angle);
                sb.AppendLine("    childPS=" + go.GetComponentsInChildren<ParticleSystem>(true).Length +
                              " renderers=" + go.GetComponentsInChildren<Renderer>(true).Length);
                var r = go.GetComponentInChildren<ParticleSystemRenderer>(true);
                if (r != null)
                    sb.AppendLine("    renderMode=" + r.renderMode +
                                  " material=" + (r.sharedMaterial != null ? r.sharedMaterial.name : "<null>"));
            }

            // ---------- ground probe at foliage cell centres ----------
            sb.AppendLine("=== GROUND PROBE (raycast down) ===");
            float[,] cells = new float[,]
            {
                {676,231},{634,230},{724,225},{527,121},{731,134},{641,183},{558,134},
                {527,225},{732,269},{530,252},{753,238},{664,171}
            };
            for (int i = 0; i < cells.GetLength(0); i++)
            {
                float x = cells[i, 0], z = cells[i, 1];
                RaycastHit hit;
                bool ok = Physics.Raycast(new Vector3(x, 400f, z), Vector3.down, out hit, 800f, ~0, QueryTriggerInteraction.Ignore);
                sb.AppendLine("  (" + x + "," + z + ") hit=" + ok +
                              (ok ? "  y=" + hit.point.y.ToString("F2") + "  collider=" + hit.collider.name : ""));
            }

            // ---------- river probe ----------
            sb.AppendLine("=== RIVER EDGE PROBE ===");
            RaycastHit rh;
            bool rok = Physics.Raycast(new Vector3(628f, 400f, 347f), Vector3.down, out rh, 800f, ~0, QueryTriggerInteraction.Ignore);
            sb.AppendLine("  (628,347) hit=" + rok + (rok ? " y=" + rh.point.y.ToString("F2") + " " + rh.collider.name : ""));

            return sb.ToString();
        }
    }
}
