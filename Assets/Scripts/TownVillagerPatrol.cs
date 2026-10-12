using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

namespace BigTigGames
{
    /// <summary>
    /// Drives town civilian NPCs along designated town street waypoints,
    /// synchronizing NavMeshAgent locomotion with Animator speed parameters.
    /// Supports both linear ping-pong and random destination lookups strictly inside Town_Street boundaries.
    /// </summary>
    [RequireComponent(typeof(NavMeshAgent))]
    [RequireComponent(typeof(Animator))]
    public class TownVillagerPatrol : MonoBehaviour
    {
        [Header("Movement Settings")]
        [Tooltip("Walking speed of the villager.")]
        public float walkSpeed = 1.2f;

        [Tooltip("Acceleration of the agent.")]
        public float acceleration = 3.5f;

        [Tooltip("Obstacle avoidance radius.")]
        public float avoidanceRadius = 0.5f;

        [Tooltip("Obstacle avoidance quality.")]
        public ObstacleAvoidanceType avoidanceQuality = ObstacleAvoidanceType.HighQualityObstacleAvoidance;

        [Tooltip("Obstacle avoidance priority (lower number = higher priority).")]
        public int avoidancePriority = 40;

        [Tooltip("How close the agent needs to be to a waypoint before proceeding to the next.")]
        public float waypointTolerance = 0.15f;

        [Tooltip("Stopping distance for NavMeshAgent.")]
        public float stoppingDistance = 0.15f;

        [Tooltip("Whether to use auto braking on NavMeshAgent.")]
        public bool autoBraking = false;

        [Tooltip("If enabled, pauses only at the terminal ends of the route rather than intermediate corner nodes.")]
        public bool pauseOnlyAtEnds = true;

        [Tooltip("If enabled, picks random points strictly inside Town_Street boundaries rather than strict linear order.")]
        public bool randomStreetDestinations = false;

        [Tooltip("Min idle wait time at each waypoint.")]
        public float minWaitTime = 1.5f;

        [Tooltip("Max idle wait time at each waypoint.")]
        public float maxWaitTime = 3.5f;

        [Tooltip("Whether to ping-pong back and forth between waypoints when in sequential mode.")]
        public bool pingPong = true;

        [Header("Animation")]
        [Tooltip("Float parameter name driving Idle <-> Walk transitions.")]
        public string speedParameterName = "Speed";

        [Tooltip("Damping time for speed parameter transitions.")]
        public float speedDampTime = 0.15f;

        [Header("Waypoints")]
        [Tooltip("Explicit patrol points. If empty, auto-populates from town street corridor.")]
        public List<Vector3> waypoints = new List<Vector3>();

        private NavMeshAgent _agent;
        private Animator _animator;
        private int _currentWaypointIndex = 0;
        private bool _isMovingForward = true;
        private float _waitTimer = 0f;
        private bool _isWaiting = false;
        private int _speedHash;

        void Awake()
        {
            _agent = GetComponent<NavMeshAgent>();
            _animator = GetComponent<Animator>();
            _speedHash = Animator.StringToHash(speedParameterName);

            ConfigureAgent();
            PopulateWaypointsIfEmpty();
        }

        void Start()
        {
            SnapToNavMesh();
            AdvanceWaypointIndex();
            MoveToNextWaypoint();
        }

        void Update()
        {
            if (_agent == null || !_agent.isActiveAndEnabled || !_agent.isOnNavMesh)
                return;

            // Update animator speed parameter
            float currentSpeed = _agent.velocity.magnitude;
            if (_animator != null)
            {
                _animator.SetFloat(_speedHash, currentSpeed, speedDampTime, Time.deltaTime);
            }

            // Waypoint progression logic
            if (_isWaiting)
            {
                _waitTimer -= Time.deltaTime;
                if (_waitTimer <= 0f)
                {
                    _isWaiting = false;
                    _agent.isStopped = false;
                    AdvanceWaypointIndex();
                    MoveToNextWaypoint();
                }
                return;
            }

            // Check if reached destination: enforce precision arrival tolerance before advancing
            if (!_agent.pathPending && _agent.remainingDistance <= Mathf.Max(_agent.stoppingDistance, waypointTolerance))
            {
                bool isTerminal = (_currentWaypointIndex == 0 || _currentWaypointIndex == waypoints.Count - 1);
                if (!pauseOnlyAtEnds || isTerminal)
                {
                    _isWaiting = true;
                    _waitTimer = Random.Range(minWaitTime, maxWaitTime);
                    _agent.isStopped = true;
                }
                else
                {
                    AdvanceWaypointIndex();
                    MoveToNextWaypoint();
                }
            }
        }

        public void ConfigureAgent()
        {
            if (_agent == null) _agent = GetComponent<NavMeshAgent>();
            if (_agent == null) return;

            _agent.speed = walkSpeed;
            _agent.acceleration = acceleration;
            _agent.radius = avoidanceRadius;
            _agent.obstacleAvoidanceType = avoidanceQuality;
            _agent.avoidancePriority = avoidancePriority;
            _agent.stoppingDistance = stoppingDistance;
            _agent.autoBraking = autoBraking;
            _agent.angularSpeed = 180f;
            _agent.height = 1.8f;
            _agent.baseOffset = 0f;

            // Enforce Town_Street area mask (Bit 3 only, Bit 0 disabled)
            int townStreetArea = NavMesh.GetAreaFromName("Town_Street");
            if (townStreetArea >= 0)
            {
                _agent.areaMask = 1 << townStreetArea;
            }
            else
            {
                _agent.areaMask = 1 << 3;
            }
        }

        public void SnapToNavMesh()
        {
            if (_agent == null) _agent = GetComponent<NavMeshAgent>();
            if (_agent == null) return;

            if (NavMesh.SamplePosition(transform.position, out NavMeshHit hit, 2.0f, _agent.areaMask))
            {
                _agent.Warp(hit.position);
            }
        }

        public static readonly Vector3[] DefaultTownCorridorWaypoints = new Vector3[]
        {
            new Vector3(616.20f, 10.00f, 245.70f),
            new Vector3(630.00f, 10.00f, 245.70f),
            new Vector3(630.00f, 10.00f, 233.00f),
            new Vector3(716.50f, 10.00f, 233.00f),
            new Vector3(716.50f, 10.00f, 260.00f)
        };

        public void PopulateWaypointsIfEmpty()
        {
            if (waypoints != null && waypoints.Count > 0)
                return;

            waypoints = new List<Vector3>();

            if (_agent == null) _agent = GetComponent<NavMeshAgent>();
            int mask = _agent != null ? _agent.areaMask : (1 << 3);

            foreach (var pt in DefaultTownCorridorWaypoints)
            {
                if (NavMesh.SamplePosition(pt, out NavMeshHit hit, 2.0f, mask))
                {
                    waypoints.Add(hit.position);
                }
                else
                {
                    waypoints.Add(pt);
                }
            }
        }

        private void MoveToNextWaypoint()
        {
            if (waypoints == null || waypoints.Count == 0 || _agent == null || !_agent.isOnNavMesh)
                return;

            Vector3 target = waypoints[_currentWaypointIndex];
            _agent.isStopped = false;
            _agent.SetDestination(target);
        }

        private void AdvanceWaypointIndex()
        {
            if (waypoints == null || waypoints.Count <= 1)
                return;

            if (randomStreetDestinations)
            {
                // Pick a random waypoint different from current
                int nextIndex;
                int attempts = 0;
                do
                {
                    nextIndex = Random.Range(0, waypoints.Count);
                    attempts++;
                } while (nextIndex == _currentWaypointIndex && attempts < 10);
                _currentWaypointIndex = nextIndex;
            }
            else if (pingPong)
            {
                if (_isMovingForward)
                {
                    _currentWaypointIndex++;
                    if (_currentWaypointIndex >= waypoints.Count)
                    {
                        _currentWaypointIndex = Mathf.Max(0, waypoints.Count - 2);
                        _isMovingForward = false;
                    }
                }
                else
                {
                    _currentWaypointIndex--;
                    if (_currentWaypointIndex < 0)
                    {
                        _currentWaypointIndex = Mathf.Min(1, waypoints.Count - 1);
                        _isMovingForward = true;
                    }
                }
            }
            else
            {
                _currentWaypointIndex = (_currentWaypointIndex + 1) % waypoints.Count;
            }
        }

        void OnDrawGizmos()
        {
            if (waypoints == null || waypoints.Count == 0)
                return;

            Gizmos.color = new Color(1f, 0f, 1f, 0.75f); // Pink/Magenta Town_Street color
            for (int i = 0; i < waypoints.Count; i++)
            {
                Gizmos.DrawWireSphere(waypoints[i], 0.35f);
                if (i < waypoints.Count - 1)
                {
                    Gizmos.DrawLine(waypoints[i] + Vector3.up * 0.1f, waypoints[i + 1] + Vector3.up * 0.1f);
                }
            }
        }

        [ContextMenu("Log Patrol Route Status")]
        public void LogRouteStatus()
        {
            Debug.Log($"[TownVillagerPatrol] Agent '{name}': Speed={walkSpeed}, AreaMask={(_agent != null ? _agent.areaMask : -1)}, Waypoints={waypoints.Count}");
        }
    }
}
