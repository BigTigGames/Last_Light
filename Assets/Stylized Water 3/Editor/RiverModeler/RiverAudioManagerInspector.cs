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

using UnityEditor;
using UnityEngine;

namespace StylizedWater3.RiverModeler
{
    [CustomEditor(typeof(RiverAudioManager))]
    public class RiverAudioManagerInspector : Editor
    {
        RiverAudioManager component;

        void OnEnable()
        {
            component = (RiverAudioManager)target;
        }
        
        public override void OnInspectorGUI()
        {
            UI.DrawNotification("This component will pool and stream Audio Sources for any rivers within earshot.");

            if (Application.isPlaying)
            {
                if(RiverAudioManager.Instance) UI.DrawNotification(RiverAudioManager.Instance.AudioListenerPresent == false, "No Audio Listener found in scene", MessageType.Error);
                
                EditorGUILayout.LabelField($"Objects in pool: {component.InactiveInPool}");
                EditorGUILayout.LabelField($"Active audio sources: {component.ActiveInPool}");
            }
            else
            {
                EditorGUILayout.HelpBox("Play mode disabled, audio will have no effect at the moment", MessageType.None);
            }
        }
    }
}