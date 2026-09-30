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

using System;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Object = UnityEngine.Object;
#if SPLINES
using UnityEngine.Splines;
#endif

namespace StylizedWater3.RiverModeler
{
    public static class RiverModelerEditor
    {
        private const int MENU_PRIORITY = 1;

        /// <summary>
        /// Mesh LOD is supported in Unity 6.2 and newer
        /// </summary>
#if UNITY_6000_2_OR_NEWER
        public const bool meshLodSupport = true;
#else
        public const bool meshLodSupport = false;
#endif
        
        public static Material GetDefaultMaterial()
        {
            string defaultMatPath = AssetDatabase.GUIDToAssetPath("bc0e4b60f99d22e47ac795dbaba30831");
            
            //If installed
            if (defaultMatPath != string.Empty)
            {
                return AssetDatabase.LoadAssetAtPath(defaultMatPath, typeof(Material)) as Material;
            }
            

            return null;
        }
        
        [MenuItem("GameObject/Spline/River", false, MENU_PRIORITY)]
        public static void CreateSplineRiver()
        {
            CreateRiver();
        }
        
        [MenuItem("GameObject/3D Object/Water/River", false, MENU_PRIORITY)]
        public static void CreateWaterRiver()
        {
            CreateRiver();
        }

        private static void CreateRiver()
        {
            GameObject parent = Selection.activeGameObject ? Selection.activeGameObject : null;
            GameObject gameObject = CreateRiverObject();
            
            ObjectFactory.PlaceGameObject(gameObject, parent);
            
            if (parent) gameObject.transform.parent = parent.transform;
            
            Selection.activeGameObject = gameObject;
        }

        public static GameObject CreateRiverObject(bool promptSplineCreation = true)
        {
            GameObject gameObject = new GameObject(GameObjectUtility.GetUniqueNameForSibling(null, "River"));
            
            RiverModeler component = gameObject.AddComponent<RiverModeler>();
            component.material = GetDefaultMaterial();

            if (promptSplineCreation)
            {
                bool addSpline =
                    EditorUtility.DisplayDialog("Create river object", "Create with a new spline?", "Yes", "No");
                if (addSpline)
                {
#if SPLINES
                    SplineContainer splineContainer = gameObject.AddComponent<SplineContainer>();

                    int knots = 5;
                    float length = 50f;

                    float heightDrop = 5f;
                    float waterfallStart = 0.45f;
                    float waterfallEnd = 0.55f;
                    Spline spline = new Spline(knots, false);

                    for (int i = 0; i <= knots; i++)
                    {
                        float t = (float)i / (float)knots;

                        float dropT = Mathf.InverseLerp(waterfallStart, waterfallEnd, t);
                        float height = -Mathf.SmoothStep(0f, heightDrop, dropT);

                        BezierKnot knot = new BezierKnot
                        {
                            Position = new Vector3(0, height, (t * length) - (length * 0.5f))
                        };
                        spline.Add(knot, TangentMode.Linear);
                    }

                    //Automatically recalculate tangents
                    spline.SetTangentMode(new SplineRange(0, spline.Count), TangentMode.AutoSmooth);

                    splineContainer.Spline.Copy(spline);

                    component.SetSplineContainer(splineContainer);
#else
                throw new Exception("The Splines package isn't installed.");
#endif
                }
            }

#if UNITY_EDITOR
            Undo.RegisterCreatedObjectUndo(gameObject, "Created River Object");
#endif
            
            component.Rebuild();

            return gameObject;
        }
        
#if SPLINES
        [MenuItem("CONTEXT/SplineContainer/Add River")]
        private static void AddRiverToSpline(MenuCommand cmd)
        {
            SplineContainer t = (SplineContainer)cmd.context;

            bool asChild = EditorUtility.DisplayDialog("Add river modeler to spline", "Add as a child object?", "Yes", "No");

            RiverModeler component = null;
            
            if (asChild)
            {
                GameObject obj = CreateRiverObject(false);
                obj.transform.parent = t.transform;

                component = obj.GetComponent<RiverModeler>();
            }
            else
            {
                if (!t.gameObject.GetComponent<RiverModeler>())
                {
                    component = t.gameObject.AddComponent<RiverModeler>();
                }
            }
            
            component.SetSplineContainer(t);
            component.Rebuild();

            EditorUtility.SetDirty(t);
        }

        [MenuItem("CONTEXT/RiverModeler/Clear Width Data")]
        private static void ClearSplineScaleData(MenuCommand cmd)
        {
            RiverModeler t = (RiverModeler)cmd.context;

            t.ResetScaleData();
            
            EditorUtility.SetDirty(t);
        }
#endif
        
        [MenuItem("GameObject/Audio/River Audio Manager", false, MENU_PRIORITY)]
        public static void CreateRiverAudioManager()
        {
            if (RiverAudioManager.Instance)
            {
                Debug.Log("A River Audio Manager already exists.", RiverAudioManager.Instance);
                EditorGUIUtility.PingObject(RiverAudioManager.Instance);
                return;
            }
            GameObject gameObject = new GameObject("River Audio Manager");
            
#if UNITY_EDITOR
            Undo.RegisterCreatedObjectUndo(gameObject, "Created River Audio object");
#endif
            
            RiverAudioManager component = gameObject.AddComponent<RiverAudioManager>();
        }
        
        public static int RebuildAllInstances()
        {
#if UNITY_6000_4_OR_NEWER
            RiverModeler[] rivers = Object.FindObjectsByType<RiverModeler>();
#else
            RiverModeler[] rivers = Object.FindObjectsByType<RiverModeler>(FindObjectsInactive.Exclude, FindObjectsSortMode.None);
#endif

            int count = 0;
            for (int i = 0; i < rivers.Length; i++)
            {
                count++;
                rivers[i].Rebuild();
            }
            return count;
        }
    }
}