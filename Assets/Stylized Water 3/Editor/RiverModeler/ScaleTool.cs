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

using UnityEditor.EditorTools;
#if SPLINES
using UnityEditor.Splines;
using UnityEngine.Splines;
#endif
using Unity.Mathematics;
using UnityEditor;
using UnityEngine;

namespace StylizedWater3.RiverModeler
{
#if SPLINES
    [EditorTool(NAME, typeof(RiverModeler))]
    public class ScaleTool : EditorTool, IDrawSelectedHandles
    {
        private const string NAME = "River Scale Tool";
        public const string IconName = "river-scale-icon-64px";
        
        private GUIContent m_IconContent;
        public override GUIContent toolbarIcon => m_IconContent;
        private const float k_HandleSize = 0.1f;

        private bool m_DisableHandles;
        
        void OnEnable()
        {
            name = NAME;
            m_IconContent = new GUIContent()
            {
                image = Resources.Load<Texture2D>(IconName),
                text = "Scale Tool",
                tooltip = "Adjust the width and displacement scale of the created river mesh."
            };
        }
        
        public override void OnToolGUI(EditorWindow window)
        {
            var modeler = target as RiverModeler;
            if (modeler == null || modeler.SplineContainer == null)
                return;

            base.OnToolGUI(window);

            Handles.color = Color.green;
            m_DisableHandles = false;

            var splines = modeler.SplineContainer.Splines;
            for (var splineIndex = 0; splineIndex < splines.Count; splineIndex++)
            {
                SplineData<float4> scaleData = modeler.GetScaleData(splineIndex);

                var nativeSpline = new NativeSpline(splines[splineIndex], modeler.SplineContainer.transform.localToWorldMatrix);

                Undo.RecordObject(modeler, "Modifying River Scale");
                
                // User defined handles to manipulate width
                DrawDataPoints(nativeSpline, scaleData);
                
                // Using the out-of the box behaviour to manipulate indexes
                nativeSpline.DataPointHandles(scaleData, true, splineIndex);
                
                if (GUI.changed)
                {
                    modeler.Rebuild(RiverModeler.ChangeFlags.Scale);
                }
            }
        }
        
        public void OnDrawHandles()
        {

        }
        
        protected bool DrawDataPoints(ISpline spline, SplineData<float4> splineData)
        {
            RiverModeler modeler = target as RiverModeler;

            var inUse = false;
            for (int dataFrameIndex = 0; dataFrameIndex < splineData.Count; dataFrameIndex++)
            {
                var dataPoint = splineData[dataFrameIndex];

                var normalizedT = SplineUtility.GetNormalizedInterpolation(spline, dataPoint.Index, splineData.PathIndexUnit);
                spline.Evaluate(normalizedT, out var position, out var tangent, out var up);

                if (DrawDataPoint(position, tangent, up, dataPoint.Value, out var result))
                {
                    dataPoint.Value = result;
                    splineData[dataFrameIndex] = dataPoint;
                    inUse = true;
                    
                    modeler.Rebuild(RiverModeler.ChangeFlags.Scale);
                }
            }
            return inUse;
        }
        
        protected bool DrawDataPoint(Vector3 position, Vector3 tangent, Vector3 up, float4 inValue, out float4 outValue)
        {
            int id = m_DisableHandles ? -1 : GUIUtility.GetControlID(FocusType.Passive);
            int id2 = m_DisableHandles ? -1 : GUIUtility.GetControlID(FocusType.Passive);

            outValue = inValue;
            if (tangent == Vector3.zero)
                return false;

            if (Event.current.type == EventType.MouseUp
                && Event.current.button != 0
                && (GUIUtility.hotControl == id || GUIUtility.hotControl == id2))
            {
                Event.current.Use();
                return false;
            }

            var handleColor = Handles.color;
            if ((GUIUtility.hotControl == id || GUIUtility.hotControl == id2))
                handleColor = Handles.selectedColor;
            else if (GUIUtility.hotControl == 0 && (HandleUtility.nearestControl == id || HandleUtility.nearestControl == id2))
                handleColor = Handles.preselectionColor;

            var splineDataTarget = target as RiverModeler;
            float riverWidth = splineDataTarget.settings.geometry.baseWidth * 0.5f;

            up = math.up();
            Vector3 right = math.normalize(math.cross(tangent, up));

            float handleScale = HandleUtility.GetHandleSize(position);
            
            Vector3 x = position + (right * inValue.x * riverWidth);
            Vector3 y = position + (up * inValue.y * handleScale);

            Vector3 width, height;
            
            using (new Handles.DrawingScope(handleColor))
            {
                Handles.color = Color.red;;
                if (Event.current.type == EventType.Repaint)
                {
                    Handles.DrawAAPolyLine(Texture2D.whiteTexture, 3f, new []{position, x});
                }
                width = Handles.Slider(id, x, right, k_HandleSize * handleScale, CustomHandleCap, 0);

                Handles.color = Color.green;
                if (Event.current.type == EventType.Repaint)
                {
                    Handles.DrawAAPolyLine(Texture2D.whiteTexture, 3f, new []{position, y});
                }
                height = Handles.Slider(id2, y, up, k_HandleSize * handleScale, CustomHandleCap, 0);
            }

            if (GUIUtility.hotControl == id && math.abs(width.x - x.x) > 0f)
            {
                outValue.x = math.distance(width, position) / riverWidth;
                return true;
            }

            if (GUIUtility.hotControl == id2 && math.abs(height.y - y.y) > 0f)
            {
                outValue.y = math.distance(height, position) / handleScale;
                return true;
            }
            
            return false;
        }
        
        public void CustomHandleCap(int controlID, Vector3 position, Quaternion rotation, float size, EventType eventType)
        {
            if (m_DisableHandles) // If disabled, do nothing unless it's a repaint event
            {
                if (Event.current.type == EventType.Repaint)
                    Handles.CubeHandleCap(controlID, position, rotation, size, eventType);
            }
            else
                Handles.CubeHandleCap(controlID, position, rotation, size, eventType);
        }
    }
#endif
}