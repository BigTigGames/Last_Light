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
using UnityEngine;
using UnityEngine.Rendering;

namespace StylizedWater3.RiverModeler
{
    public static class SettingsEditors
    {
        public class Geometry : UI.Section.SectionEditor
        {
            RiverModeler component;
            
            SerializedProperty baseWidth;
            SerializedProperty minEdgeDistance;
            SerializedProperty widthEdgeDistance;
            SerializedProperty simplifyStraight;
            SerializedProperty roundedEnds;
            
            SerializedProperty lodLevels;
            SerializedProperty lodReduction;
            SerializedProperty lodSelectionSlope;
            
            SerializedProperty displacementStrength;
            SerializedProperty displacementSlopeInfluence;
            SerializedProperty displacementScale;
            
            SerializedProperty twistCorrection;
            
            #if SPLINES
            private static Texture2D _ScaleIcon;
            private static Texture2D ScaleIcon => _ScaleIcon ??= UI.Icons.LoadFromResources(ScaleTool.IconName);
            #endif
            
            private static bool drawWireFrame
            {
                get => SessionState.GetBool("RM_DrawWireFrame", false);
                set => SessionState.SetBool("RM_DrawWireFrame", value);
            }
            
            public override void OnEnable()
            {
                component = (RiverModeler)target;
                
                baseWidth = settings.FindPropertyRelative("baseWidth");
                
                minEdgeDistance = settings.FindPropertyRelative("minEdgeDistance");
                widthEdgeDistance = settings.FindPropertyRelative("widthEdgeDistance");
                simplifyStraight = settings.FindPropertyRelative("simplifyStraight");
                roundedEnds = settings.FindPropertyRelative("roundedEnds");
                
                lodLevels = settings.FindPropertyRelative("lodLevels");
                lodReduction = settings.FindPropertyRelative("lodReduction");
                lodSelectionSlope = settings.FindPropertyRelative("lodSelectionSlope");
                
                displacementStrength = settings.FindPropertyRelative("displacementStrength");
                displacementSlopeInfluence = settings.FindPropertyRelative("displacementSlopeInfluence");
                displacementScale = settings.FindPropertyRelative("displacementScale");
                
                twistCorrection = settings.FindPropertyRelative("twistCorrection");
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                EditorGUI.BeginChangeCheck();
                
                EditorGUILayout.PropertyField(baseWidth);

                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
                
                #if SPLINES
                using (new EditorGUILayout.HorizontalScope())
                {
                    GUILayout.FlexibleSpace();

                    var active = ToolManager.activeToolType == typeof(ScaleTool);
            
                    string label = active ? "Close" : "Open";
            
                    EditorGUI.BeginChangeCheck();
                    GUILayout.Toggle(active, new GUIContent($"  {label} Editor", ScaleIcon), "Button", GUILayout.Width(120f), GUILayout.Height(EditorGUIUtility.singleLineHeight + 5f));
            
                    if (EditorGUI.EndChangeCheck())
                    {
                        if (!active) ToolManager.SetActiveTool<ScaleTool>();
                        else ToolManager.RestorePreviousTool();
                    }

                    if (GUILayout.Button(new GUIContent("▼"), GUILayout.MaxHeight(EditorGUIUtility.singleLineHeight + 5f)))
                    {
                        GenericMenu menu = new GenericMenu();
                        
                        menu.AddItem(new GUIContent("Clear Scale data"), false, () =>
                        {
                            component.ResetScaleData();
                            EditorUtility.SetDirty(component);
                            component.Rebuild();
                        });
                            
                        menu.ShowAsContext();
                    }
                }
                #endif
                
                EditorGUILayout.Separator();

                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("Edge loops", EditorStyles.boldLabel);
                    drawWireFrame = GUILayout.Toggle(drawWireFrame,
                        new GUIContent("", EditorGUIUtility.IconContent("d_MainStageView").image,
                            "Toggle wire frame display"), "MiniButtonLeft", GUILayout.Width(30f),
                        GUILayout.Height(22f));
                }
                
                EditorGUI.BeginChangeCheck();

                EditorGUILayout.PropertyField(minEdgeDistance, new GUIContent("Distance over length", minEdgeDistance.tooltip));
                EditorGUILayout.PropertyField(widthEdgeDistance, new GUIContent("Distance over width", widthEdgeDistance.tooltip));
                EditorGUILayout.PropertyField(simplifyStraight);
                EditorGUILayout.PropertyField(roundedEnds);
                
                EditorGUILayout.Space();

                EditorGUILayout.LabelField("Turbulence", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(displacementStrength);
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(displacementSlopeInfluence, new GUIContent("By slope", displacementSlopeInfluence.tooltip));
                EditorGUI.indentLevel--;
                EditorGUILayout.PropertyField(displacementScale);
                
                EditorGUILayout.Space();
                
                EditorGUILayout.LabelField("Level of detail", EditorStyles.boldLabel);
                #pragma warning disable CS0162
                if(RiverModelerEditor.meshLodSupport)
                {
                    EditorGUILayout.PropertyField(lodLevels, new GUIContent("Levels", lodLevels.tooltip));
                    EditorGUILayout.PropertyField(lodReduction, new GUIContent("Reduction %", lodReduction.tooltip));
                    EditorGUILayout.PropertyField(lodSelectionSlope, new GUIContent("Selection bias", lodSelectionSlope.tooltip));
                }
                #pragma warning restore CS0162
                UI.DrawNotification(RiverModelerEditor.meshLodSupport == false, "LOD generation requires Unity 6.2+", MessageType.Info);

                EditorGUILayout.Space();

                EditorGUILayout.LabelField("Spline", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(twistCorrection);
                
                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
            }

            private static Material WireframeMaterial;
            public override void OnSceneGUI()
            {
                if (!drawWireFrame) return;
                
                if (!WireframeMaterial)
                {
                    WireframeMaterial = new Material(Shader.Find("Unlit/Color"));
                    WireframeMaterial.color = new Color(0,0,0, 0.25f);
                    WireframeMaterial.mainTexture = Texture2D.whiteTexture;
                    WireframeMaterial.hideFlags = HideFlags.DontSave;
                }

                WireframeMaterial.SetPass(0);
                GL.wireframe = true;
                
                foreach (var river in component.rivers)
                {
                    if(!river) continue;
                    foreach (var segment in river.Segments)
                    {
                        if(!segment || !segment.mesh) continue;
                        
                        Matrix4x4 matrix = Matrix4x4.TRS(
                            segment.transform.position,
                            segment.transform.rotation,
                            segment.transform.lossyScale
                        );

                        Graphics.DrawMeshNow(segment.mesh, matrix);

                    }
                }
                GL.wireframe = false;
            }

            public override void OnDisable()
            {
                CoreUtils.Destroy(WireframeMaterial);
            }
        }
        
        public class Foam : UI.Section.SectionEditor
        {
            RiverModeler component;
            Material material;

            SerializedProperty displacementFoam;
            
            SerializedProperty cascadeAngleThreshold;
            SerializedProperty cascadeAngleFalloff;
            
            SerializedProperty enableCascadeParticles;
            SerializedProperty cascadeParticleSize;
            
            SerializedProperty enableSplashParticles;
            SerializedProperty splashParticleCount;
            SerializedProperty splashThreshold;
            SerializedProperty splashParticleSize;
            SerializedProperty velocityStrength;
            
            public override void OnEnable()
            {
                component = (RiverModeler)target;
                material = component.material;

                displacementFoam = settings.FindPropertyRelative("displacementFoam");
                
                cascadeAngleThreshold = settings.FindPropertyRelative("cascadeAngleThreshold");
                cascadeAngleFalloff = settings.FindPropertyRelative("cascadeAngleFalloff");
                enableCascadeParticles = settings.FindPropertyRelative("enableCascadeParticles");
                cascadeParticleSize = settings.FindPropertyRelative("cascadeParticleSize");
                
                enableSplashParticles = settings.FindPropertyRelative("enableSplashParticles");
                splashParticleCount = settings.FindPropertyRelative("splashParticleCount");
                splashThreshold = settings.FindPropertyRelative("splashThreshold");
                splashParticleSize = settings.FindPropertyRelative("splashParticleSize");
                velocityStrength = settings.FindPropertyRelative("velocityStrength");
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                if (material)
                {
                    int vertexColorProp = ShaderParams.Properties._VertexColorFoam;
                    if (material.HasProperty(vertexColorProp))
                    {
                        UI.DrawNotification(material.GetFloat(vertexColorProp) == 0, "Vertex Color Foam is disabled on this material. Enable it to add procedural surface foam", "Enable", () =>
                        {
                            material.SetFloat(vertexColorProp, 1);
                            EditorUtility.SetDirty(material);
                        }, MessageType.Warning);
                    }
                }
                
                EditorGUI.BeginChangeCheck();

                EditorGUILayout.PropertyField(displacementFoam);
                
                EditorGUILayout.Separator();
                
                EditorGUILayout.PropertyField(cascadeAngleThreshold);
                EditorGUILayout.PropertyField(cascadeAngleFalloff);
                
                EditorGUILayout.Separator();
                
                EditorGUILayout.PropertyField(enableCascadeParticles);

                if (enableCascadeParticles.boolValue)
                {
                    EditorGUILayout.PropertyField(cascadeParticleSize);
                }
                
                EditorGUILayout.Separator();
                
                EditorGUILayout.PropertyField(enableSplashParticles);
                
                if (enableSplashParticles.boolValue)
                {
                    EditorGUILayout.PropertyField(splashParticleCount);
                    EditorGUILayout.PropertyField(splashThreshold);
                    EditorGUILayout.PropertyField(splashParticleSize);
                }
                
                EditorGUILayout.Separator();
                    
                EditorGUILayout.PropertyField(velocityStrength);
                
                if (enableCascadeParticles.boolValue || enableSplashParticles.boolValue)
                {
#if !VFX_GRAPH
                    UI.DrawNotification("Particle features require the Visual Effects Graph package to be installed", MessageType.Error);
#else
                    UI.DrawNotification(!component.foamVFX,"The foam VFX Graph is not assigned to the component, particles will fail to render.", MessageType.Error);
#endif
                }

                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
            }
        }
        
        public class Transparency : UI.Section.SectionEditor
        {
            RiverModeler component;
            private Material material;

            SerializedProperty startGradientFalloff;
            SerializedProperty endGradientFalloff;

            SerializedProperty widthGradientFalloff;
            
            public override void OnEnable()
            {
                component = (RiverModeler)target;

                startGradientFalloff = settings.FindPropertyRelative("startGradientFalloff");
                endGradientFalloff = settings.FindPropertyRelative("endGradientFalloff");

                widthGradientFalloff = settings.FindPropertyRelative("widthGradientFalloff");
                
                material = component.material;
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                if (material)
                {
                    int vertexColorProp = ShaderParams.Properties._VertexColorTransparency;
                    if (material.HasProperty(vertexColorProp))
                    {
                        UI.DrawNotification(material.GetFloat(vertexColorProp) == 0, "Vertex Color Transparency is disabled on this material. Enable it to add procedural transparency", "Enable", () =>
                        {
                            material.SetFloat(vertexColorProp, 1);
                            EditorUtility.SetDirty(material);
                        }, MessageType.Warning);
                    }
                }
                EditorGUI.BeginChangeCheck();

                EditorGUILayout.LabelField("Length", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(startGradientFalloff);
                EditorGUILayout.PropertyField(endGradientFalloff);

                EditorGUILayout.Space();

                EditorGUILayout.LabelField("Width", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(widthGradientFalloff);
                
                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
            }
        }

        public class Audio : UI.Section.SectionEditor
        {
            RiverModeler component;

            SerializedProperty enable;
            SerializedProperty profile;

            public override void OnEnable()
            {
                component = (RiverModeler)target;

                enable = settings.FindPropertyRelative("enable");
                profile = settings.FindPropertyRelative("profile");
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                UI.DrawNotification(RiverAudioManager.Instance == null, "A River Audio Manager must be present in the scene to use audio", "Create", RiverModelerEditor.CreateRiverAudioManager, MessageType.Warning);
  
                EditorGUI.BeginChangeCheck();

                EditorGUILayout.PropertyField(enable);

                using (new EditorGUI.DisabledScope(enable.boolValue == false))
                {
                    EditorGUILayout.PropertyField(profile);
                }

                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
            }
        }
        
        public class Output : UI.Section.SectionEditor
        {
            RiverModeler component;

            SerializedProperty maxSegmentLength;
            SerializedProperty boxTriggers;
            SerializedProperty collider;
            
            private static bool visualize
            {
                get => SessionState.GetBool("RM_VisualizeSegments", false);
                set => SessionState.SetBool("RM_VisualizeSegments", value);
            }
            
            public override void OnEnable()
            {
                component = (RiverModeler)target;

                maxSegmentLength = settings.FindPropertyRelative("maxSegmentLength");
                boxTriggers = settings.FindPropertyRelative("boxTriggers");
                collider = settings.FindPropertyRelative("collider");
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                EditorGUI.BeginChangeCheck();

                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.PropertyField(maxSegmentLength, new GUIContent("Segment Length", maxSegmentLength.tooltip),GUILayout.Width(EditorGUIUtility.labelWidth + 90f));

                    visualize = GUILayout.Toggle(visualize,
                        new GUIContent("", EditorGUIUtility.IconContent((visualize ? "animationvisibilitytoggleon" : "animationvisibilitytoggleoff")).image, "Visualize with colors"), "MiniButtonRight", GUILayout.MaxWidth(30f),
                        GUILayout.MaxHeight(19f));
                }
                
                EditorGUILayout.Separator();
                
                EditorGUILayout.LabelField("Physics", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(boxTriggers);
                EditorGUILayout.PropertyField(collider);

                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
            }
            
            private static Material SegmentMaterial;
            public override void OnSceneGUI()
            {
                if (!visualize) return;
                
                if (!SegmentMaterial)
                {
                    SegmentMaterial = new Material(Shader.Find("Unlit/Color"));
                    SegmentMaterial.color = new Color(0,0,0, 0.25f);
                    SegmentMaterial.mainTexture = Texture2D.whiteTexture;
                    SegmentMaterial.hideFlags = HideFlags.DontSave;
                }
                
                Color color = Color.white;
                for (int r = 0; r < component.rivers.Count; r++)
                {
                    SplineRiver river = component.rivers[r];
 
                    if(!river) continue;
                    
                    int segmentCount = river.Segments.Count;
                    for (int s = 0; s < segmentCount; s++)
                    {
                        RiverSegment segment = river.Segments[s];
                        
                        if(!segment || !segment.mesh) continue;
                        
                        float t = (s) / 8f;
                        t -= Mathf.Floor(t);
                        
                        color = Color.HSVToRGB(t, 0.95f, 1f);
                        color.a = 1f;
                        
                        SegmentMaterial.SetPass(0);
                        SegmentMaterial.color = color;
                        
                        Matrix4x4 matrix = Matrix4x4.TRS(
                            segment.transform.position,
                            segment.transform.rotation,
                            segment.transform.lossyScale
                        );

                        Graphics.DrawMeshNow(segment.mesh, matrix);
                    }
                }
            }
            
            public override void OnDisable()
            {
                CoreUtils.Destroy(SegmentMaterial);
            }
        }
        
        public class MicroVerse : UI.Section.SectionEditor
        {
            RiverModeler component;
            
            public override void OnEnable()
            {
                component = (RiverModeler)target;
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                #if MICROVERSE
                EditorGUI.BeginChangeCheck();

                int arraySize = settings.arraySize;
                for (int i = 0; i < arraySize; i++)
                {
                    SerializedProperty microVersePathSetting = settings.GetArrayElementAtIndex(i);
                    
                    SerializedProperty splinePath = microVersePathSetting.FindPropertyRelative("splinePath");

                    using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
                    {
                        using (new EditorGUILayout.HorizontalScope())
                        {
                            EditorGUILayout.LabelField($"#{i}", EditorStyles.boldLabel);

                            if (GUILayout.Button("Delete", EditorStyles.miniButton, GUILayout.Width(60f)))
                            {
                                settings.DeleteArrayElementAtIndex(i);
                                changed = true;
                                break;
                            }
                        }
                        
                        EditorGUILayout.PropertyField(splinePath);

                        if (splinePath.objectReferenceValue)
                        {
                            JBooth.MicroVerseCore.SplinePath splinePathComponent = (JBooth.MicroVerseCore.SplinePath)splinePath.objectReferenceValue;
                            string label = "Modifies: ";
                            if(splinePathComponent.modifyHeightMap) label += "Height";
                            if(splinePathComponent.modifySplatMap) label += " Textures";
                            EditorGUILayout.LabelField(label, EditorStyles.miniLabel);
                            
                            EditorGUILayout.Space();

                            if (splinePathComponent.modifyHeightMap)
                            {
                                EditorGUILayout.LabelField("Bank (Height)", EditorStyles.boldLabel);
                                EditorGUILayout.PropertyField(microVersePathSetting.FindPropertyRelative("bankHeight"));
                                EditorGUILayout.PropertyField(microVersePathSetting.FindPropertyRelative("bankWidth"));
                                EditorGUILayout.PropertyField(
                                    microVersePathSetting.FindPropertyRelative("bankFalloff"));

                                EditorGUILayout.Separator();
                                
                                EditorGUILayout.LabelField("Bed", EditorStyles.boldLabel);
                                EditorGUILayout.PropertyField(microVersePathSetting.FindPropertyRelative("bedDepth"));
                                EditorGUILayout.PropertyField(microVersePathSetting.FindPropertyRelative("bedSmoothness"));
                                
                                EditorGUILayout.Separator();
                            }

                            if (splinePathComponent.modifySplatMap)
                            {
                                EditorGUILayout.Separator();
                                
                                EditorGUILayout.LabelField("Bank (Texture)", EditorStyles.boldLabel);
                                EditorGUILayout.PropertyField(
                                    microVersePathSetting.FindPropertyRelative("bankSplatWidth"));
                                EditorGUILayout.PropertyField(
                                    microVersePathSetting.FindPropertyRelative("bankSplatSmoothness"));

                                EditorGUILayout.Separator();
                            }
                            
                            EditorGUILayout.PropertyField(microVersePathSetting.FindPropertyRelative("offset"));
                            EditorGUILayout.Separator();
                        }
                    }
                    
                    EditorGUILayout.Separator();
                }

                if (arraySize == 0)
                {
                    EditorGUILayout.HelpBox("Add a Spline Path configuration to control.", MessageType.Info);
                }
                
                using (new EditorGUILayout.HorizontalScope())
                {
                    //GUILayout.FlexibleSpace();

                    GUIContent addContent = EditorGUIUtility.IconContent("Toolbar Plus");
                    addContent.tooltip = "Add Spline Path configuration";

                    if (GUILayout.Button(addContent))
                    {
                        settings.InsertArrayElementAtIndex(settings.arraySize);

                        SerializedProperty newElement = settings.GetArrayElementAtIndex(settings.arraySize - 1);
                        newElement.FindPropertyRelative("splinePath").objectReferenceValue = null;

                        changed = true;
                    }
                }
                
                if (EditorGUI.EndChangeCheck())
                {
                    changed = true;
                }
                #endif
            }
        }
        
        public class Events : UI.Section.SectionEditor
        {
            RiverModeler component;

            SerializedProperty onPreRebuild;
            SerializedProperty onPostRebuild;

            public override void OnEnable()
            {
                component = (RiverModeler)target;

                onPreRebuild = serializedObject.FindProperty("onPreRebuild");
                onPostRebuild = serializedObject.FindProperty("onPostRebuild");
            }

            public override void OnInspectorGUI(ref bool changed)
            {
                //EditorGUI.BeginChangeCheck();

                EditorGUILayout.PropertyField(onPreRebuild);
                EditorGUILayout.PropertyField(onPostRebuild);

                //changed |= EditorGUI.EndChangeCheck();
            }
        }
    }
}