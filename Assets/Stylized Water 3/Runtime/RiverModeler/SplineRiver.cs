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
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace StylizedWater3.RiverModeler
{
    public class SplineRiver : MonoBehaviour
    {
        [SerializeField, HideInInspector]
        private RiverModeler _owner;
        public RiverModeler Owner { get => _owner; internal set => _owner = value;}
        
        [SerializeField, HideInInspector]
        private int _splineIndex;
        public int SplineIndex { get => _splineIndex; internal set => _splineIndex = value; }
        
        [SerializeField, HideInInspector] private List<RiverSegment> segments = new List<RiverSegment>();
        public List<RiverSegment> Segments { get => segments; internal set => segments = value; }
        
        public static SplineRiver Create(RiverModeler modeler)
        {
            GameObject go = new GameObject("Spline River");
            
#if UNITY_EDITOR
            Undo.RegisterCreatedObjectUndo(go, $"Create Spline Meshes container new spline");
#endif
            
            go.transform.SetParent(modeler.transform);
            go.transform.localPosition = Vector3.zero;
            //go.transform.SetSiblingIndex(splineIndex);
            go.transform.hideFlags = HideFlags.NotEditable;
            
            SplineRiver river = go.AddComponent<SplineRiver>();
            
            return river;
        }
        
        public void PrepareContainers(int count)
        {
            //Remove any null references or ones that were manually removes from the transform
            for (int i = segments.Count - 1; i >= 0; i--)
            {
                if (!segments[i].gameObject || segments[i].gameObject.transform.parent != this.transform)
                {
                    segments.RemoveAt(i);
                }
            }
            
            int currentCount = segments.Count;
            
            int delta = count - currentCount;
            
            //Trim excess segments
            if (delta < 0)
            {
                //Debug.Log($"Trimming {currentCount - count} segments", owner);
                
                for (int i = currentCount-1; i >= count; i--)
                {
                    CoreUtils.Destroy(segments[i].gameObject);
                    segments.RemoveAt(i);
                }
            }
            //Append newly needed segments
            else
            {
                //Debug.Log($"Adding {delta} segments", owner);

                for (int i = 0; i < delta; i++)
                {
                    RiverSegment segment = RiverSegment.Create(this.transform);
                    
                    segments.Add(segment);
                }
            }
        }

        public void SetProperties(Material material, int index)
        {
            SplineIndex = index;

            for (int i = 0; i < segments.Count; i++)
            {
                segments[i].SetMaterial(material);
                segments[i].SetSortingOrder(index);
            }
        }
    }
}