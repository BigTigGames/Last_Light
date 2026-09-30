// Stylized Water 3 © Staggart Creations (http://staggart.xyz)
// COPYRIGHT PROTECTED UNDER THE UNITY ASSET STORE EULA (https://unity.com/legal/as-terms)
//
// ⚠️ WARNING: UNAUTHORIZED USE OR DISTRIBUTION IS STRICTLY PROHIBITED
// • Copying, referencing, or reverse-engineering this source code for the creation of new Asset Store or derivative products,
//   or any other publicly distributed content is strictly forbidden and will result in legal action.
// • Studying this file for the purpose of reproducing its functionality in your own assets or tools is not permitted.
// • If you are viewing this file as a reference, please close it immediately to avoid unintentional design influence or potential EULA violations.
// • Uploading this file or any derivative of it to a public GitHub or similar repository will trigger an automated DMCA takedown request.
// • Studying to understand for personal, educational or integration purposes is allowed, studying to reproduce is not.

using System.Collections.Generic;
using UnityEditor;
using UnityEditor.EditorTools;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering.Universal;
#if SPLINES
using UnityEditor.Splines;
#endif

namespace StylizedWater3.RiverModeler
{
    [CustomEditor(typeof(RiverModeler))]
    public class RiverModelerInspector : Editor
    {
        private RiverModeler component;

        private SerializedProperty splineContainer;
        private SerializedProperty material;
        private SerializedProperty foamVFX;
        
        private SerializedProperty settings;
        private SerializedProperty rebuildOnStart;
        
        private RiverModeler.ChangeFlags changeFlags;
        
#if MICROVERSE && SPLINES
        private const bool MICROVERSE_INSTALLED = true;
#else
        private const bool MICROVERSE_INSTALLED = false;
#endif
        
        internal readonly List<UI.Section> sections = new List<UI.Section>();
        StylizedWaterEditor.MaterialSelector materialSelector;
        internal bool isAllowedToRebuild;
        internal bool isPrefab;
        internal bool isInspectingPrefab;
        
        //Material
        private bool riverMat;
        private bool matZWrite;
        private bool matLegacyBehaviour;

        private UI.Section geometrySection;
        private UI.Section foamSection;
        private UI.Section transparencySection;
        private UI.Section audioSection;
        private UI.Section outputSection;
        private UI.Section eventsSection;
        private UI.Section microverseSection;
        
        private void OnEnable()
        {
            #if SPLINES
            splineContainer = serializedObject.FindProperty("_splineContainer");
            #endif
            material = serializedObject.FindProperty("material");
            foamVFX = serializedObject.FindProperty("foamVFX");
            settings = serializedObject.FindProperty("settings");
            rebuildOnStart = serializedObject.FindProperty("rebuildOnStart");
            
            component = (RiverModeler)target;
            
            geometrySection = UI.Section.Create<SettingsEditors.Geometry>(this, "Geometry",  new GUIContent("Geometry", EditorGUIUtility.IconContent("Mesh Icon").image), settings.FindPropertyRelative("geometry"));
            sections.Add(geometrySection);

            foamSection = UI.Section.Create<SettingsEditors.Foam>(this, "Foam",  new GUIContent("Foam", UI.Icons.LoadFromResources("river-foam-icon-64px")), settings.FindPropertyRelative("foam"));
            sections.Add(foamSection);

            transparencySection = UI.Section.Create<SettingsEditors.Transparency>(this, "Transparency",  new GUIContent("Transparency", UI.Icons.LoadFromResources("river-transparency-icon-64px")), settings.FindPropertyRelative("transparency"));
            sections.Add(transparencySection);

            audioSection = UI.Section.Create<SettingsEditors.Audio>(this, "Audio",  new GUIContent("Audio", EditorGUIUtility.IconContent("AudioSource Icon").image), settings.FindPropertyRelative("audio"));
            sections.Add(audioSection);
  
            outputSection = UI.Section.Create<SettingsEditors.Output>(this, "Output",  new GUIContent("Output", EditorGUIUtility.IconContent("GameObject Icon").image), settings.FindPropertyRelative("output"));
            sections.Add(outputSection);

            eventsSection = UI.Section.Create<SettingsEditors.Events>(this, "Events",  new GUIContent("Events", UI.Icons.Event), settings);
            sections.Add(eventsSection);
            
#pragma warning disable CS0162
            if (MICROVERSE_INSTALLED)
            {
                microverseSection = UI.Section.Create<SettingsEditors.MicroVerse>(this, "MicroVerse",  new GUIContent("MicroVerse", UI.Icons.LoadFromResources("microverse_spline_icon")), settings.FindPropertyRelative("microVersePathSettings"));
                sections.Add(microverseSection);
            }
#pragma warning restore CS0162

            materialSelector = new StylizedWaterEditor.MaterialSelector(new[]
            {
                "d2a358901c7ad80418593cbcc0b06713"
            });         
            
            Validate();
        }

        private void DrawNotifications()
        {
#if URP
            UI.DrawNotification( !AssetInfo.MeetsMinimumVersion(RiverModelerExtension.extension.minBaseVersion), "Version mismatch, requires Stylized Water 3 v" + RiverModelerExtension.extension.minBaseVersion +".\n\nUpdate to avoid any issues or resolve (shader) errors", "Update", () => AssetInfo.OpenInPackageManager(), MessageType.Error);
            
            UI.DrawNotification(UniversalRenderPipeline.asset == null, "The Universal Render Pipeline is not active", MessageType.Error);
#else
            UI.DrawNotification("The Universal Render Pipeline package is not installed!", MessageType.Error);
#endif
            
            if (Unity.Burst.BurstCompiler.IsEnabled == false)
            {
                EditorGUILayout.HelpBox("Burst compilation is disabled, expect performance degradation", MessageType.Warning);
                EditorGUILayout.Separator();
            }
            
            if (isAllowedToRebuild == false)
            {
                EditorGUILayout.HelpBox("\nRebuilding disabled. This object is not a scene instance." +
                                        "\n\nOpen the prefab to edit it.\n", MessageType.Info);
            }
        }

        private void DrawSection(UI.Section section, RiverModeler.ChangeFlags flag)
        {
            bool changed = false;
            section.DrawHeader(() => UI.Section.SwitchTo(sections, section, false));
            EditorGUILayout.BeginFadeGroup(section.anim.faded);
            {
                if (section.Expanded)
                {
                    section.DrawUI(ref changed);
                }
            }
            EditorGUILayout.EndFadeGroup();
            
            if(changed && flag != RiverModeler.ChangeFlags.None) changeFlags |= flag;
        }
        
        public override void OnInspectorGUI()
        {
            EditorGUILayout.LabelField($"{AssetInfo.ASSET_NAME } v{AssetInfo.INSTALLED_VERSION}: River Modeler v{RiverModelerExtension.extension.version}", EditorStyles.centeredGreyMiniLabel);
            EditorGUILayout.Space();

            DrawNotifications();

            serializedObject.Update();
            EditorGUI.BeginChangeCheck();

            changeFlags = RiverModeler.ChangeFlags.None;
            
#if SPLINES
            using (new EditorGUILayout.HorizontalScope())
            {
                EditorGUI.BeginChangeCheck();
                EditorGUILayout.PropertyField(splineContainer);
                if (EditorGUI.EndChangeCheck())
                {
                    if (splineContainer.objectReferenceValue)
                    {
                        changeFlags |= RiverModeler.ChangeFlags.Spline;
                    }
                }

                EditorGUI.BeginDisabledGroup(splineContainer.objectReferenceValue == null);
                var splineToolActive = ToolManager.activeContextType != null && ToolManager.activeContextType == typeof(SplineToolContext);
                    
                EditorGUI.BeginChangeCheck();
                GUILayout.Toggle(splineToolActive, new GUIContent("Edit", "Toggle Spline Editor"), "Button", GUILayout.MaxWidth(60f));

                if (EditorGUI.EndChangeCheck())
                {
                    if (!splineToolActive)
                    {
                        Selection.activeGameObject = component.SplineContainer.gameObject;
                        EditorApplication.delayCall += ToolManager.SetActiveContext<SplineToolContext>;
                    }
                    else ToolManager.SetActiveContext<GameObjectToolContext>();
                }         

                EditorGUI.EndDisabledGroup();
            }

            if (splineContainer.objectReferenceValue)
            {
                EditorGUILayout.Space();
                
                UI.MaterialPropertyField(material, material.displayName, materialSelector, () =>
                {
                    RebuildTargets();
                    Validate();
                });

                if (material.objectReferenceValue)
                {
                    UI.DrawNotification(!riverMat, "Material doesn't have River mode enabled.", "Enable",() =>
                    {
                        Material mat = (Material)material.objectReferenceValue;
                        mat.SetFloat(ShaderParams.Properties._RiverModeOn, 1);
                        EditorUtility.SetDirty(mat);
                        riverMat = true;
                    }, MessageType.Error);
                    
                    UI.DrawNotification(matZWrite, "Material has the Depth Writing (ZWrite) option enable, this makes alpha blending with other water bodies impossible", "Enable",() =>
                    {
                        Material mat = (Material)material.objectReferenceValue;
                        mat.SetFloat(ShaderParams.Properties._ZWrite, 0);
                        EditorUtility.SetDirty(mat);
                        matZWrite = false;
                    }, MessageType.Warning);
                    
                    UI.DrawNotification(riverMat && matLegacyBehaviour, "Material has legacy river behaviour enabled. It should be disabled to let this tool bake in shading data.", "Disable",() =>
                    {
                        Material mat = (Material)material.objectReferenceValue;
                        mat.SetFloat(ShaderParams.Properties._RiverModeLegacy, 0);
                        EditorUtility.SetDirty(mat);
                        matLegacyBehaviour = false;
                    }, MessageType.Error);
                }
                else
                {
                    UI.DrawNotification(true, "No material assigned", "Use default", () =>
                    {
                        Material defaultMat = RiverModelerEditor.GetDefaultMaterial();
                        material.objectReferenceValue = defaultMat;
                        EditorUtility.SetDirty(this);
                        Validate();
                    }, MessageType.Error);
                }
#if VFX_GRAPH
                EditorGUI.BeginChangeCheck();
                EditorGUILayout.PropertyField(foamVFX);
                if (EditorGUI.EndChangeCheck())
                {
                    changeFlags |= RiverModeler.ChangeFlags.Foam;
                }
                if (foamVFX.objectReferenceValue == null)
                {
                    EditorGUILayout.HelpBox("A VFX Graph must be assigned.\n\n" +
                                            "If you've installed the Visual Effect Graph package AFTER installing this asset, this will be missing. If so, reimport the asset from the Package Manager.", MessageType.Error);
                }
#endif
                EditorGUILayout.PropertyField(rebuildOnStart);
                EditorGUILayout.Separator();
                
                DrawSection(geometrySection, RiverModeler.ChangeFlags.Geometry);
                DrawSection(foamSection, RiverModeler.ChangeFlags.Foam);
                DrawSection(transparencySection, RiverModeler.ChangeFlags.Transparency);
                DrawSection(audioSection, RiverModeler.ChangeFlags.Audio);
                DrawSection(outputSection, RiverModeler.ChangeFlags.Geometry);
                DrawSection(eventsSection, RiverModeler.ChangeFlags.None);
                #pragma warning disable CS0162
                if (MICROVERSE_INSTALLED)
                {
                    DrawSection(microverseSection, RiverModeler.ChangeFlags.MicroVerse);
                }
                #pragma warning restore CS0162
                
                EditorGUILayout.Space();

                //base.OnInspectorGUI();

                if (EditorGUI.EndChangeCheck())
                {
                    serializedObject.ApplyModifiedProperties();

                    if (changeFlags != RiverModeler.ChangeFlags.None && isAllowedToRebuild)
                    {
                        RebuildTargets();
                    }
                }
                
                using (new EditorGUILayout.HorizontalScope())
                {
                    GUILayout.FlexibleSpace();
                    if(GUILayout.Button("  Rebuild  ", EditorStyles.miniButtonMid))
                    {
                        changeFlags = RiverModeler.ChangeFlags.All;
                        RebuildTargets();
                    }
                    GUILayout.FlexibleSpace();
                }
                EditorGUILayout.LabelField($"Generation time: {component.LastProcessingTime}ms", EditorStyles.miniLabel);
            }
            else
            {
                EditorGUILayout.HelpBox("Assign a Spline Container to create this river from", MessageType.Info);
            }
#else
            EditorGUILayout.HelpBox("The Spline package isn't installed, please install this through the Package Manager to use this component", MessageType.Error);
#endif
            
            UI.DrawFooter();
        }

        private void Validate()
        {
            isPrefab = PrefabUtility.IsPartOfPrefabInstance(target)|| PrefabStageUtility.GetCurrentPrefabStage();
            isInspectingPrefab = PrefabUtility.IsPartOfPrefabAsset(this.target) && this.component.gameObject.scene.name != string.Empty;
            isAllowedToRebuild = component.IsAllowedToRebuild();
            
            Material mat = material.objectReferenceValue as Material;
            if (mat)
            {
                riverMat = mat.GetFloat(ShaderParams.Properties._RiverModeOn) > 0;
                matZWrite = mat.GetFloat(ShaderParams.Properties._ZWrite) > 0;
                
                matLegacyBehaviour = mat.GetFloat(ShaderParams.Properties._RiverModeLegacy) > 0;
            }
        }

        private void RebuildTargets()
        {
            foreach (var m_target in targets)
            {
                RiverModeler modeler = (RiverModeler)m_target;
                
                //mesher.RebuildSplineCache();
                modeler.Rebuild(changeFlags);
                EditorUtility.SetDirty(modeler);
            }
        }
        
        private void OnSceneGUI()
        {
            foreach (UI.Section section in sections)
            {
                if (section.Expanded)
                {
                    section.DrawSceneGUI();
                }
            }
        }
        
        void OnDisable()
        {
            foreach (var section in sections)
            {
                section.Disable();
            }
        }
    }
    
    [CustomEditor(typeof(SplineRiver))]
    public class SplineRiverInspector : Editor
    {
        SplineRiver component;

        void OnEnable()
        {
            component = (SplineRiver)target;
        }
        
        public override void OnInspectorGUI()
        {
            EditorGUILayout.HelpBox("This component houses the individual river segments", MessageType.Info);

            using (new EditorGUI.DisabledGroupScope(true))
            {
                EditorGUILayout.ObjectField("Owner", component.Owner, typeof(RiverModeler), false);
                EditorGUILayout.LabelField($"Spline index: {component.SplineIndex}");
                EditorGUILayout.LabelField($"Segments: {component.Segments.Count}");
            }
        }
    }

    [CustomEditor(typeof(RiverSegment))]
    public class RiverSegmentInspector : Editor
    {
        RiverSegment component;
        
        void OnEnable()
        {
            component = (RiverSegment)target;
        }
        
        public override void OnInspectorGUI()
        {
            EditorGUILayout.HelpBox("This component houses the individual river segments", MessageType.Info);
            
            EditorGUILayout.LabelField($"Spline curve range: {component.CurveRange}");
            EditorGUILayout.LabelField($"Audio emitters: {component.AudioEmitters.Length}");
            #if VFX_GRAPH
            EditorGUILayout.LabelField($"Particle emitters: {component.ParticleCount}");
            #endif
        }
    }
}