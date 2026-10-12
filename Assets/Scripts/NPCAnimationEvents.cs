using UnityEngine;

/// <summary>
/// Silently catches and routes animation events (such as OnFootstep and OnLand)
/// fired by StarterAssets humanoid clips, preventing console missing receiver warnings.
/// </summary>
public class NPCAnimationEvents : MonoBehaviour
{
    private void OnFootstep(AnimationEvent animationEvent)
    {
        // Silently handled - prevents missing receiver warning
    }

    private void OnLand(AnimationEvent animationEvent)
    {
        // Silently handled - prevents missing receiver warning
    }
}
