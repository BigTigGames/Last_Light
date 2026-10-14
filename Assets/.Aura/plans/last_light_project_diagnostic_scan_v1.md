# Last_Light — Project Diagnostic Scan (Read-Only)

## Objective
Deliver a verified inventory and health assessment of the `Last_Light` project (editor state, packages, assets, custom systems, URP/performance configuration, defects found) using only read operations — no project data was modified.

## Changes
- 'Assets/.Aura/plans/last_light_project_diagnostic_scan_v1.md' - (create) this report only. **No project files changed by this pass.**

## Relevant Assets and Quirks

**Editor / platform facts**
- Editor: **Unity 6000.3.6f1** (`ProjectSettings/ProjectVersion.txt`). Not in Play Mode; no selection; compiler clean (`check_compile_errors` → "No compile errors"); console buffer empty (no warnings/errors captured this session).
- Active scene: `Assets/Enviornment_Scene/Luminous_Lake 1.unity`; colour space Linear; product `Last_Light` / `DefaultCompany`; default res 1024x768; vSync off, quality level = **PC** (`QualitySettings.m_CurrentQuality: 1`).
- Addressables, Netcode, ProBuilder, TextMeshPro (package) are **not** installed — the root `Unity.ProBuilder*.csproj` / `HFDownloader.csproj` files are stale IDE artifacts (`search_installed_packages probuilder` → "cannot be found").
- Repo-adjacent clutter at root: `.kiro/`, `count_batch_push.sh`, `unity_batch_push.sh.save`, `ProfilerCaptures/`, `Logs/`, `Temp/`.

**Packages — 54 total (20 feature packages + 34 built-in modules)**
- Rendering: `com.unity.render-pipelines.universal` **17.3.0**, `render-pipelines.core` 17.3.0, `visualeffectgraph` 17.3.0 (URP 17.3 = Unity 6.3 generation).
- Gameplay/tooling: `cinemachine 3.1.7`, `inputsystem 1.18.0`, `ai.navigation 2.0.9`, `splines 2.9.0`, `terrain-tools 5.3.2`, `timeline 1.8.10`, `ugui 2.0.0`, `test-framework 1.6.0`, `formats.fbx 5.1.6`, `visualscripting 1.9.9`, `multiplayer.center 1.0.1`, `ide.rider 3.0.38`, `ide.visualstudio 2.0.26`.
- **Embedded/local source packages** (`Packages/packages-lock.json`): `com.distantlands.cozy.core 3.6.23` (embedded), `com.unity.ai.assistant 2.20.0-pre.2` (embedded), `com.unity.terrain-tools` (embedded).
- Git packages: `com.coplaydev.unity-mcp 10.3.1-beta.7`, `com.ramenvr.aura-unity 1.4.1`.
- Transitive only: `burst 1.8.27`, `collections 2.6.2`, `mathematics 1.3.3`, `cloud.gltfast 6.14.1`.

**Assets**
- **55 scenes** total. Project scenes (6) in `Assets/Enviornment_Scene`: `Luminous_Lake 1` (active), `Luminous_Lake`, `Ancient_Ruins`, `Echoing_Woods`, `Sun_Dappled_Hills`, `Whispering_Meadows`. Plus `Assets/_Recovery/0.unity` (7.2 MB) and `_Recovery/1.unity` — unmerged crash-recovery copies.
- **9,424 prefabs / 871 materials / 1,612 textures / 98 audio clips.** The vast majority of prefabs+materials come from the `Assets/polyperfect/Poly Universal Pack` vendor demo library (19 demo scenes inside it).
- Vendor art trees: `Third_Party_assets/` (Daniel Mistage Fantasy Village, Polyart DreamscapeEastLands, Raygeas Suntail Village, TriForge Fantasy Forest/Fantasy Worlds), `Stylized Water 3` (own Runtime/Editor/Shaders + asmdefs), `Starter Assets` (own asmdefs), `Samples/COZY 3_ Stylized Weather/3.6.23`.
- **Custom authored assets** are thin: `Assets/Custom_Assets/Boat` (fantasyBoat.fbx + 2 PBR maps + `Boat_HP.mat`), `Custom_Assets/Bridges` (4 bridge FBXs + rope-bridge textures), `Custom_Assets/portal` (portal.fbx + 3 mats + 7 maps). No prefabs inside `Custom_Assets` — FBX are placed directly in-scene.
- **Custom scripts (4, all in `Assets/Scripts`, no asmdef → compiled into `Assembly-CSharp`)**: `WaterFloatingBodySetup.cs`, `TownVillagerPatrol.cs` (namespace `BigTigGames`), `StylizedUnderwaterTrigger.cs` (namespace `StylizedWater3`), `NPCAnimationEvents.cs`.
- Input: single `Assets/InputSystem_Actions.inputactions` (Player map: Move/Look/Attack/Interact/Crouch/Jump/Previous/Next/Sprint; UI map; 5 control schemes), wired as `com.unity.input.settings.actions` in `EditorBuildSettings`.

**Rendering / performance configuration (as configured, not measured)**
- Active pipeline: `GraphicsSettings.m_CustomRenderPipeline` = guid `4b83569d…` = **`Assets/Settings/PC_RPAsset.asset`** (verified via `.meta`); the `Mobile` quality level uses `5e6cbd92…` = `Mobile_RPAsset.asset`.
- `PC_RPAsset`: HDR on, MSAA 1x, render scale 1.0, depth + opaque textures required, SRP Batcher on, **dynamic batching off**, additional-light shadows **off** (4 lights/object, 256px), main-light shadowmap 1024 @ shadow distance 65 with 4 cascades + soft shadows, GPU Resident Drawer **off**. Volume profile `10fc4df2…`.
- `PC_Renderer` features: `ScreenSpaceAmbientOcclusion` (active, **Downsample 0 = full-res**, Source DepthNormals, Samples 1, Radius 0.3) and `StylizedWater3.StylizedWaterRenderFeature` (active; height prepass range 500 m, 4 cells/unit, max res 4096, disabled in Scene view). Native Render Pass on.
- Quality (PC): vSync off, `lodBias 2`, anisotropic **Force Enable**, **streaming mipmaps off**, shadow distance 40 (overridden by the URP asset's 65), terrain basemap 1000 / detail 80 / tree billboard 50 / max 50 trees.
- Active scene contents (top level): `Main Camera` (FreeCamera), `Terrain 1`, `Water_Buoyancy_Manager` (AlignToWater), `River_Spline` (RiverModeler + SplineContainer), `Cozy Weather Sphere` (CozyWeather), `TriForge Foliage Controller`, `Boat` (LODGroup + MeshCollider + AlignToWater), and large `Rocks` / `Trees` / `Props` / `Buildings` groups (hierarchy enumeration exceeded 450 entries and was still truncated inside `Trees`) → scene is object-heavy; baked occlusion data present (`Enviornment_Scene/Luminous_Lake 1/OcclusionCullingData.asset`) but **no baked `NavMeshData` asset exists in that folder**.

**Defects found (each evidence-backed)**
1. **Build Settings are broken**: `EditorBuildSettings.asset` lists only `Assets/Scenes/SampleScene.unity` with `enabled: 0`, and `Assets/Scenes/` **does not exist** → no enabled scene to launch.
2. **`FloatingProp` tag missing**: tags are only `CinemachineTarget`, `Item`, `Door`, `FX Block Zone`. `WaterFloatingBodySetup.floatingTag = "FloatingProp"` therefore throws and takes the `UnityException` warning path (`Assets/Scripts/WaterFloatingBodySetup.cs:149-157`), leaving the `propsRoot` scan as the only discovery path — and `propsRoot` is unset because the script isn't in the scene.
3. **`Town_Street` NavMesh area undefined**: `NavMeshAreas.asset` names only 0 Walkable / 1 Not Walkable / 2 Jump. `TownVillagerPatrol.ConfigureAgent()` falls back to `_agent.areaMask = 1 << 3` (an unnamed area), so town-patrol masking silently depends on an unnamed slot.
4. **Custom systems not instantiated in the active scene**: no `TownVillagerPatrol`, `NavMeshAgent`, `StylizedUnderwaterTrigger`, or `Volume` component exists in `Luminous_Lake 1` — the four scripts are authored but not wired up (only `AlignToWater` is present).
5. **No profiler data to assess runtime cost**: `get_worst_cpu_frames` / `get_worst_gc_frames` both return "No valid frame data found in profiler." A prior raw capture exists (`ProfilerCaptures/Last_Light_2026-10-08_12-49-51.{data,bc7,highlights,png}`), but its PNG is a 256x116 thumbnail, not metric data.
6. Two unreferenced `_Recovery/*.unity` scenes (one 7.2 MB) sit in the asset tree; `Luminous_Lake.unity` and `Luminous_Lake 1.unity` coexist (8.6 MB vs 7.0 MB) — duplicate/parked scene risk.

## Steps
- [x] 1. Report delivered (this file); no mutation performed in Plan Mode. [depends: none]
  - Note: all inventory/config facts above were read this run; the read-only pass touched no scene, prefab, script, or ProjectSettings file.
  - Verification note (unity_verification_agent, read-only): versions / compile-clean / active-scene contents / tags / build settings / NavMesh areas / pipeline+quality all confirmed. One disputed number: the **scene count**. `query_project_assets t:Scene` (AssetDatabase) reports **55**, while the agent's file-name enumeration counted **49** `.unity` files (and 13 `polyperfect` demo scenes rather than 19). Treat the scene count as **49–55 — exact figure unconfirmed**; the prefab/material/texture/audio totals were not independently reproducible in the verification context.

## Verify
- Re-run this scan any time with: `get_unity_editor_state`, `check_compile_errors`, `get_unity_logs`, `list_packages`, `query_project_assets` (t:Scene / t:Prefab / t:Material / t:Texture2D / t:AudioClip), `get_tags_and_layers`, `read_file` on `ProjectSettings/{ProjectVersion,GraphicsSettings,QualitySettings,EditorBuildSettings,NavMeshAreas}.asset`, `list_game_objects_in_hierarchy`.
- Runtime cost verification (Play Mode, Agent mode only): start a Profiler session, then `get_worst_cpu_frames` + `get_worst_gc_frames`, and `list_objects_with_high_polygon_count` on the active scene.

## Tooling Initialized In This Session
- **Verified working (read-only)**: `get_unity_editor_state`, `check_compile_errors`, `get_unity_logs`, `list_packages`, `search_installed_packages`, `query_project_assets`, `get_asset_meta`, `get_tags_and_layers`, `get_input_action_asset`, `list_files`, `read_file`, `list_code_definition_names`, `list_game_objects_in_hierarchy`, `list_all_prefabs_with_bounding_boxes`, `get_worst_cpu_frames`, `get_worst_gc_frames`.
- **Degraded**: `grep` across all of `Assets` timed out (whole-tree regex); scoped searches (`Assets/Scripts`, single files) work. Parallel `query_project_assets` calls serialise ("superseded by a newer call").
- **Not usable in Plan Mode, available in Agent Mode**: scene/asset/component mutation (`create_game_object`, `set_property`, `manage_prefabs`, …), `write_file`/`edit_file`/`create_script`, `execute_script`, `batch_execute`, `manage_editor` (play/stop), `run_play_mode_sequence`, `unity_verification_agent`, `manage_profiler`/`start_profiler_capture`, `capture_editor_screenshot`/`capture_scene_object`/`capture_ui_canvas`, `run_tests`, `manage_build`/`manage_packages`, `install_unity_package`, `unity_reflect`, `unity_docs`, image/model generation.
- **No Unity editor tools were disabled or lost** — the tool catalog is loaded on demand, and every capability above remains reachable (mutation/generation/play-mode tools are gated by Plan Mode policy, not missing).
