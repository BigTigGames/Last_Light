using System.Collections.Generic;
using UnityEngine;

namespace BigTigGames
{
    /// <summary>
    /// Data-only holder for the master set of sampled town-street navigation destinations.
    /// Stores the points as a serialized array on a single GameObject so no per-point
    /// transforms are instantiated in the hierarchy. Draws editor-only gizmos for inspection.
    /// </summary>
    [DisallowMultipleComponent]
    public class WaypointPool : MonoBehaviour
    {
        [Tooltip("Master pool of sampled Town_Street (Area 3) navigation destinations, in world space.")]
        public Vector3[] points = new Vector3[0];

        /// <summary>Number of points currently held in the pool.</summary>
        public int Count => points != null ? points.Length : 0;

        public Vector3 this[int index] => points[index];

        /// <summary>
        /// Returns a new list containing the pool in a deterministic, uniquely seeded order.
        /// The same seed always produces the same permutation.
        /// </summary>
        public List<Vector3> ShuffledCopy(int seed)
        {
            var copy = new List<Vector3>(points ?? new Vector3[0]);
            var rng = new System.Random(seed);
            for (int i = copy.Count - 1; i > 0; i--)
            {
                int j = rng.Next(i + 1);
                Vector3 tmp = copy[i];
                copy[i] = copy[j];
                copy[j] = tmp;
            }
            return copy;
        }

        void OnDrawGizmos()
        {
            if (points == null || points.Length == 0) return;

            Gizmos.color = new Color(0.65f, 0.30f, 1f, 0.9f);
            for (int i = 0; i < points.Length; i++)
            {
                Gizmos.DrawWireSphere(points[i], 0.5f);
                Gizmos.DrawLine(points[i] + Vector3.up * 0.1f, points[i] + Vector3.up * 1.5f);
            }
        }
    }
}
