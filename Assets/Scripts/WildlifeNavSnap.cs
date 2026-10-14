using UnityEngine;
using UnityEngine.AI;

/// <summary>
/// Clamps a wandering animal onto the nearest walkable NavMesh the moment it awakes,
/// so a deer can never spawn floating above the terrain or wedged inside props.
/// Must run AFTER NavMeshSurface (-102) so the baked NavMesh is already registered,
/// and BEFORE the default-order AI scripts so the agent binds at the corrected position.
/// </summary>
[DefaultExecutionOrder(-50)]
[DisallowMultipleComponent]
public class WildlifeNavSnap : MonoBehaviour
{
    [Tooltip("How far to look for a walkable NavMesh polygon around the spawn position.")]
    [SerializeField] float m_SearchRadius = 4f;

    void Awake()
    {
        var agent = GetComponent<NavMeshAgent>();
        if (agent == null)
            return;

        NavMeshHit hit;
        if (NavMesh.SamplePosition(transform.position, out hit, m_SearchRadius, agent.areaMask))
        {
            transform.position = hit.position;

            if (agent.isOnNavMesh)
                agent.Warp(hit.position);
        }
        else
        {
            Debug.LogWarning(
                name + ": WildlifeNavSnap found no NavMesh within " + m_SearchRadius +
                " m of " + transform.position + ". The agent will not bind.", this);
        }
    }
}
