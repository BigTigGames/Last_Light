using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace StylizedWater3
{
    /// <summary>
    /// Manages underwater transition and atmospheric fog effects when the camera enters the water plane.
    /// Works alongside the local URP Volume to provide seamless visual transitions.
    /// </summary>
    [ExecuteAlways]
    [RequireComponent(typeof(BoxCollider))]
    [RequireComponent(typeof(Volume))]
    public class StylizedUnderwaterTrigger : MonoBehaviour
    {
        [Header("Water Reference")]
        [Tooltip("WaterObject or Transform representing the water surface plane.")]
        public Transform waterPlane;
        public float waterSurfaceY = 8.88f;

        [Header("Underwater Fog Settings")]
        public bool controlSceneFog = true;
        public Color underwaterFogColor = new Color(0.10f, 0.42f, 0.52f, 1f);
        public float underwaterFogDensity = 0.035f;

        [Header("State")]
        [SerializeField] private bool isUnderwater;
        public bool IsUnderwater => isUnderwater;

        private Camera targetCamera;
        private bool cachedFogEnabled;
        private Color cachedFogColor;
        private float cachedFogDensity;
        private FogMode cachedFogMode;
        private BoxCollider boxCollider;
        private Volume volume;

        private void OnEnable()
        {
            boxCollider = GetComponent<BoxCollider>();
            volume = GetComponent<Volume>();
            CacheDefaultFog();
        }

        private void CacheDefaultFog()
        {
            cachedFogEnabled = RenderSettings.fog;
            cachedFogColor = RenderSettings.fogColor;
            cachedFogDensity = RenderSettings.fogDensity;
            cachedFogMode = RenderSettings.fogMode;
        }

        private void Update()
        {
            if (targetCamera == null)
            {
                targetCamera = Camera.main;
                if (targetCamera == null)
                    targetCamera = FindAnyObjectByType<Camera>();
            }

            if (targetCamera == null) return;

            // Ensure camera renders post processing
            var camData = targetCamera.GetComponent<UniversalAdditionalCameraData>();
            if (camData != null && !camData.renderPostProcessing)
            {
                camData.renderPostProcessing = true;
            }

            Vector3 camPos = targetCamera.transform.position;
            bool insideBounds = boxCollider != null && boxCollider.bounds.Contains(camPos);
            bool belowWaterPlane = camPos.y <= (waterPlane != null ? waterPlane.position.y : waterSurfaceY);

            bool shouldBeUnderwater = insideBounds && belowWaterPlane;

            if (shouldBeUnderwater != isUnderwater)
            {
                isUnderwater = shouldBeUnderwater;
                OnUnderwaterStateChanged(isUnderwater);
            }
        }

        private void OnUnderwaterStateChanged(bool underwater)
        {
            if (!controlSceneFog) return;

            if (underwater)
            {
                CacheDefaultFog();
                RenderSettings.fog = true;
                RenderSettings.fogMode = FogMode.ExponentialSquared;
                RenderSettings.fogColor = underwaterFogColor;
                RenderSettings.fogDensity = underwaterFogDensity;
            }
            else
            {
                RenderSettings.fog = cachedFogEnabled;
                RenderSettings.fogColor = cachedFogColor;
                RenderSettings.fogDensity = cachedFogDensity;
                RenderSettings.fogMode = cachedFogMode;
            }
        }

        private void OnDisable()
        {
            if (isUnderwater && controlSceneFog)
            {
                RenderSettings.fog = cachedFogEnabled;
                RenderSettings.fogColor = cachedFogColor;
                RenderSettings.fogDensity = cachedFogDensity;
                RenderSettings.fogMode = cachedFogMode;
                isUnderwater = false;
            }
        }

        private void OnDrawGizmosSelected()
        {
            if (boxCollider == null) boxCollider = GetComponent<BoxCollider>();
            if (boxCollider != null)
            {
                Gizmos.color = new Color(0f, 0.6f, 0.9f, 0.3f);
                Gizmos.DrawCube(boxCollider.bounds.center, boxCollider.bounds.size);
                Gizmos.color = new Color(0f, 0.8f, 1f, 0.9f);
                Gizmos.DrawWireCube(boxCollider.bounds.center, boxCollider.bounds.size);
            }
        }
    }
}
