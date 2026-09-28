using UnityEngine;

public class TerrainGrassSpawner : MonoBehaviour
{
    [Header("Terrain Setup")]
    public Terrain targetTerrain;
    
    [Tooltip("The index of your path Terrain Layer (Soil is index 1 based on your earlier setup)")]
    public int pathLayerIndex = 1; 
    
    [Range(0f, 1f)] public float pathThreshold = 0.2f;

    [Header("Grass Settings")]
    [Tooltip("The index of the Grass Detail Prototype to paint (0, 1, or 2)")]
    public int detailIndex = 0;
    
    [Range(1, 16)] public int maxGrassDensity = 8;

    [Header("Density Control (Noise)")]
    public bool useNoise = true;
    [Range(0.01f, 0.5f)] public float noiseScale = 0.1f;
    [Range(0f, 1f)] public float noiseThreshold = 0.4f;

    [Header("Sizing Overrides")]
    public bool overrideGrassSize = false;
    public float minWidth = 0.8f;
    public float maxWidth = 1.2f;
    public float minHeight = 0.8f;
    public float maxHeight = 1.2f;

    // This attribute creates a button when you right-click the script component header!
    [ContextMenu("GENERATE GRASS NOW")]
    public void GenerateGrass()
    {
        if (targetTerrain == null)
        {
            Debug.LogError("Please assign a Target Terrain.");
            return;
        }

        TerrainData terrainData = targetTerrain.terrainData;
        int detailWidth = terrainData.detailWidth;
        int detailHeight = terrainData.detailHeight;
        int alphamapWidth = terrainData.alphamapWidth;
        int alphamapHeight = terrainData.alphamapHeight;

        if (overrideGrassSize && terrainData.detailPrototypes.Length > detailIndex)
        {
            DetailPrototype[] prototypes = terrainData.detailPrototypes;
            prototypes[detailIndex].minWidth = Mathf.Max(0.1f, minWidth);
            prototypes[detailIndex].maxWidth = maxWidth;
            prototypes[detailIndex].minHeight = Mathf.Max(0.1f, minHeight);
            prototypes[detailIndex].maxHeight = maxHeight;
            terrainData.detailPrototypes = prototypes;
        }

        float[,,] alphamaps = terrainData.GetAlphamaps(0, 0, alphamapWidth, alphamapHeight);
        int layerCount = alphamaps.GetLength(2);

        if (pathLayerIndex >= layerCount)
        {
            Debug.LogError($"Path Layer Index {pathLayerIndex} is out of bounds. Your terrain only has {layerCount} layers.");
            return;
        }

        int[,] detailMap = new int[detailWidth, detailHeight];

        for (int y = 0; y < detailHeight; y++)
        {
            for (int x = 0; x < detailWidth; x++)
            {
                int alphaX = Mathf.FloorToInt((float)x / detailWidth * alphamapWidth);
                int alphaY = Mathf.FloorToInt((float)y / detailHeight * alphamapHeight);

                float pathWeight = alphamaps[alphaY, alphaX, pathLayerIndex];

                if (pathWeight < pathThreshold)
                {
                    if (useNoise)
                    {
                        float sampleNoise = Mathf.PerlinNoise(x * noiseScale, y * noiseScale);
                        if (sampleNoise > noiseThreshold)
                        {
                            detailMap[y, x] = Mathf.RoundToInt(maxGrassDensity * ((sampleNoise - noiseThreshold) / (1f - noiseThreshold)));
                        }
                        else
                        {
                            detailMap[y, x] = 0;
                        }
                    }
                    else
                    {
                        detailMap[y, x] = maxGrassDensity;
                    }
                }
                else
                {
                    detailMap[y, x] = 0;
                }
            }
        }

        terrainData.SetDetailLayer(0, 0, detailIndex, detailMap);
        Debug.Log($"Successfully scattered grass on Detail Index {detailIndex}!");
    }

    [ContextMenu("CLEAR GRASS NOW")]
    public void ClearGrass()
    {
        if (targetTerrain == null) return;
        TerrainData terrainData = targetTerrain.terrainData;
        int[,] emptyMap = new int[terrainData.detailWidth, terrainData.detailHeight];
        terrainData.SetDetailLayer(0, 0, detailIndex, emptyMap);
        Debug.Log($"Cleared grass detail layer slot {detailIndex}.");
    }
}
