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
    ///
    /// This component also owns the marketplace interaction behaviour. On arriving at a waypoint it may
    /// divert to the closest reachable stall, hold the interaction clip, run the talking loop and then
    /// resume its broad route. The Animator parameters 'isAtStall' and 'isTalking' drive that sequence on
    /// the AC_Town_Villager_Stall controller.
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

        [Header("Grounding")]
        [Tooltip("Vertical correction written to NavMeshAgent.baseOffset. The baked Town_Street NavMesh " +
                 "surface sits ~8.3 cm above the NavMeshRoad_Strip road top, so a zero offset embeds the " +
                 "feet mesh in the road. Raised by this amount to sit the feet flush on the road.")]
        public float groundOffset = 0.04096f;

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

        [Header("Marketplace Stalls")]
        [Range(0f, 100f)]
        [Tooltip("Chance (%) that arriving at a waypoint diverts to the closest marketplace stall " +
                 "instead of continuing the broad route.")]
        public float stallChancePercentage = 25f;

        [Tooltip("Marketplace stall footprints. The closest reachable one is used for a diversion.")]
        public List<StallAnchor> marketplaceStalls = new List<StallAnchor>();

        [Tooltip("How far outside the stall footprint the villager stands while interacting.")]
        public float stallStandoff = 1.25f;

        [Tooltip("Min seconds holding the interaction clip at the stall.")]
        public float stallDwellMin = 6f;

        [Tooltip("Max seconds holding the interaction clip at the stall.")]
        public float stallDwellMax = 10f;

        [Tooltip("Min seconds holding the talking / gesture loop after interacting.")]
        public float stallTalkMin = 4f;

        [Tooltip("Max seconds holding the talking / gesture loop after interacting.")]
        public float stallTalkMax = 6f;

        [Tooltip("Safety cap on a single walk to a stall.")]
        public float maxStallTravelSeconds = 60f;

        [Tooltip("Turn rate used while facing a stall.")]
        public float stallTurnSpeedDegPerSec = 200f;

        [Header("Social Interaction")]
        [Tooltip("Radius scanned for a free villager to strike up a conversation with.")]
        public float socialRadius = 1.75f;

        [Tooltip("Chance (%) that passing a free nearby villager starts a conversation.")]
        [Range(0f, 100f)]
        public float socialChancePercentage = 15f;

        [Tooltip("Seconds between proximity scans. Staggered per villager so they don't all scan on the same frame.")]
        public float socialScanInterval = 0.5f;

        [Tooltip("Min seconds a conversation lasts.")]
        public float socialTalkMin = 7f;

        [Tooltip("Max seconds a conversation lasts.")]
        public float socialTalkMax = 14f;

        [Tooltip("Individual cooldown (seconds) applied after a conversation ends.")]
        public float socialCooldownSeconds = 30f;

        [Tooltip("Exponential smoothing rate for the Quaternion.Slerp used to turn and face the partner. Higher = snappier.")]
        public float socialTurnSmoothRate = 10f;

        /// <summary>A stall footprint, used to derive a standoff point from the villager's approach direction.</summary>
        [System.Serializable]
        public struct StallAnchor
        {
            public string name;
            public Vector3 centre;
            public Vector2 halfExtents;
        }

        /// <summary>Area slot reserved for the cobblestone town street in
        /// ProjectSettings/NavMeshAreas.asset. Keep this in sync with that asset.</summary>
        public const int TownStreetAreaIndex = 3;

        /// <summary>Name of the NavMesh area the patrol agent is restricted to.</summary>
        public const string TownStreetAreaName = "Town_Street";

        /// <summary>World Y of the town street walking surface: the top of the NavMeshRoad_Strip collider
        /// that runs under the whole patrol corridor. Patrol destinations are clamped to this plane; the
        /// authored 10.0 corridor plane and the baked NavMesh (10.162420) both sit off it.</summary>
        public const float TownStreetGroundY = 10.07908f;

        /// <summary>Animator bool driving the stall interaction clip.</summary>
        public const string StallInteractionParam = "isAtStall";

        /// <summary>Animator bool driving the talking / gesture loop.</summary>
        public const string StallTalkingParam = "isTalking";

        private enum StallPhase { None, Travelling, Interact, Talk }

        private enum SocialPhase { None, Engaged }

        /// <summary>Every enabled villager, so the proximity scan needs no physics query or layer setup.</summary>
        private static readonly List<TownVillagerPatrol> ActiveVillagers = new List<TownVillagerPatrol>();

        /// <summary>Statics survive a domain reload when Enter Play Mode Options disable it, so clear explicitly.</summary>
        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
        private static void ResetStaticState()
        {
            ActiveVillagers.Clear();
        }

        private NavMeshAgent _agent;
        private Animator _animator;
        private int _currentWaypointIndex = 0;
        private bool _isMovingForward = true;
        private float _waitTimer = 0f;
        private bool _isWaiting = false;
        private int _speedHash;

        private bool _ready;
        private bool _arrivalResolved;
        private bool _stallCapable;
        private bool _defaultUpdateRotation = true;
        private StallPhase _stallPhase = StallPhase.None;
        private float _stallTimer;
        private float _stallTravelled;
        private Vector3 _stallFace;
        private int _atStallHash;
        private int _talkingHash;

        private SocialPhase _socialPhase = SocialPhase.None;
        private TownVillagerPatrol _socialPartner;
        private float _socialTimer;
        private float _socialScanTimer;
        private float _socialCooldownTimer;
        private float _socialSavedSpeed;

        void Awake()
        {
            _agent = GetComponent<NavMeshAgent>();
            _animator = GetComponent<Animator>();

            _speedHash = Animator.StringToHash(speedParameterName);
            _atStallHash = Animator.StringToHash(StallInteractionParam);
            _talkingHash = Animator.StringToHash(StallTalkingParam);

            // The inert system stub under _SYSTEM_MANAGERS carries this component on an inactive
            // GameObject with no agent wired up; bail out before anything can dereference it.
            if (_agent == null)
            {
                Debug.LogWarning($"[{nameof(TownVillagerPatrol)}] '{name}' has no NavMeshAgent; patrol inert.", this);
                return;
            }

            // Only drive the stall parameters when the assigned controller actually declares them,
            // so a villager on a plain locomotion controller logs no Animator warnings.
            _stallCapable = _animator != null
                            && HasBoolParameter(_animator, StallInteractionParam)
                            && HasBoolParameter(_animator, StallTalkingParam);

            _defaultUpdateRotation = _agent.updateRotation;

            ConfigureAgent();
            PopulateWaypointsIfEmpty();

            // Stagger the first scan so thirteen villagers don't all sweep on the same frame.
            _socialScanTimer = Random.Range(0f, Mathf.Max(0.01f, socialScanInterval));

            _ready = true;
        }

        void OnEnable()
        {
            if (!ActiveVillagers.Contains(this))
                ActiveVillagers.Add(this);
        }

        void Start()
        {
            if (!_ready) return;

            SnapToNavMesh();
            AdvanceWaypointIndex();
            MoveToNextWaypoint();
        }

        void OnDisable()
        {
            ActiveVillagers.Remove(this);

            // Never leave a partner holding a reference to a villager that has stopped updating.
            _socialPhase = SocialPhase.None;
            _socialPartner = null;

            if (!_ready) return;

            _stallPhase = StallPhase.None;
            _isWaiting = false;

            if (_agent != null)
            {
                _agent.updateRotation = _defaultUpdateRotation;
                _agent.speed = walkSpeed;
                if (_agent.isOnNavMesh) _agent.isStopped = true;
            }

            SetStallParams(false, false);
        }

        void Update()
        {
            if (!_ready || _agent == null || !_agent.isActiveAndEnabled || !_agent.isOnNavMesh)
                return;

            // Update animator speed parameter
            float currentSpeed = _agent.velocity.magnitude;
            if (_animator != null)
            {
                _animator.SetFloat(_speedHash, currentSpeed, speedDampTime, Time.deltaTime);
            }

            // ------------------------------------------------------------------ social conversation
            if (_socialPhase == SocialPhase.Engaged)
            {
                UpdateSocialConversation();
                return;
            }

            if (_socialCooldownTimer > 0f)
                _socialCooldownTimer -= Time.deltaTime;

            _socialScanTimer -= Time.deltaTime;
            if (_socialScanTimer <= 0f)
            {
                _socialScanTimer = socialScanInterval;
                if (TryBeginSocialConversation())
                    return;
            }

            // ------------------------------------------------------------------ stall diversion
            switch (_stallPhase)
            {
                case StallPhase.Travelling:
                    _stallTravelled += Time.deltaTime;
                    if (ArrivedAtDestination() || _stallTravelled >= maxStallTravelSeconds)
                        BeginStallInteraction();
                    return;

                case StallPhase.Interact:
                case StallPhase.Talk:
                    _stallTimer -= Time.deltaTime;
                    FaceTowards(_stallFace);
                    if (_stallTimer <= 0f)
                    {
                        if (_stallPhase == StallPhase.Interact)
                        {
                            _stallPhase = StallPhase.Talk;
                            _stallTimer = Random.Range(stallTalkMin, stallTalkMax);
                            SetStallParams(false, true);
                        }
                        else
                        {
                            EndStallDiversion();
                        }
                    }
                    return;
            }

            // ------------------------------------------------------------------ broad route
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
            if (ArrivedAtDestination())
            {
                if (!_arrivalResolved)
                {
                    _arrivalResolved = true;

                    // one roll per arrival: divert to the closest stall, otherwise stay on the long route
                    if (TryBeginStallDiversion())
                        return;
                }

                bool isTerminal = waypoints != null && waypoints.Count > 1 &&
                                  (_currentWaypointIndex == 0 || _currentWaypointIndex == waypoints.Count - 1);

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

        // ------------------------------------------------------------------ stall behaviour

        /// <summary>Rolls the stall chance and, on a pass, sends the villager to the closest reachable stall.</summary>
        private bool TryBeginStallDiversion()
        {
            if (!_stallCapable || stallChancePercentage <= 0f) return false;
            if (marketplaceStalls == null || marketplaceStalls.Count == 0) return false;
            if (Random.Range(0f, 100f) >= stallChancePercentage) return false;

            // No reachable stall from here: stay on the broad route rather than stalling the villager.
            if (!TryFindClosestStall(out Vector3 stop, out Vector3 face)) return false;

            _agent.isStopped = false;
            if (!_agent.SetDestination(stop)) return false;

            _stallPhase = StallPhase.Travelling;
            _stallTravelled = 0f;
            _stallFace = face;
            return true;
        }

        private void BeginStallInteraction()
        {
            _agent.isStopped = true;
            _agent.ResetPath();
            _agent.updateRotation = false;

            _stallPhase = StallPhase.Interact;
            _stallTimer = Random.Range(stallDwellMin, stallDwellMax);
            SetStallParams(true, false);
        }

        private void EndStallDiversion()
        {
            SetStallParams(false, false);

            _stallPhase = StallPhase.None;
            _agent.updateRotation = _defaultUpdateRotation;
            if (_agent.isOnNavMesh) _agent.isStopped = false;

            // resume the broad route from the node after the one that triggered the diversion
            AdvanceWaypointIndex();
            MoveToNextWaypoint();
        }

        private bool ArrivedAtDestination()
        {
            if (_agent == null || !_agent.isOnNavMesh) return true;
            if (_agent.pathPending) return false;
            // A partial or invalid path will never close the gap; treat it as arrived.
            if (_agent.pathStatus != NavMeshPathStatus.PathComplete) return true;

            float remaining = _agent.remainingDistance;
            return !float.IsInfinity(remaining) && remaining <= Mathf.Max(_agent.stoppingDistance, waypointTolerance);
        }

        /// <summary>Picks the reachable stall with the shortest walk from the villager's current position.</summary>
        private bool TryFindClosestStall(out Vector3 stop, out Vector3 face)
        {
            stop = Vector3.zero;
            face = Vector3.zero;

            float bestPathLength = float.MaxValue;
            bool found = false;

            for (int i = 0; i < marketplaceStalls.Count; i++)
            {
                StallAnchor anchor = marketplaceStalls[i];

                Vector3 candidate = StallStandoffPoint(transform.position, anchor);
                if (!NavMesh.SamplePosition(candidate, out NavMeshHit hit, 2f, _agent.areaMask)) continue;
                candidate = hit.position;

                var path = new NavMeshPath();
                if (!NavMesh.CalculatePath(transform.position, candidate, _agent.areaMask, path)) continue;
                if (path.status != NavMeshPathStatus.PathComplete) continue;

                float length = PathLength(path);
                if (length >= bestPathLength) continue;

                bestPathLength = length;
                stop = path.corners[path.corners.Length - 1];
                face = ClosestPointOnFootprint(stop, anchor);
                found = true;
            }

            return found;
        }

        /// <summary>Nearest point on the stall's horizontally-expanded footprint boundary.</summary>
        private Vector3 StallStandoffPoint(Vector3 from, StallAnchor anchor)
        {
            float halfX = Mathf.Max(0f, anchor.halfExtents.x) + stallStandoff;
            float halfZ = Mathf.Max(0f, anchor.halfExtents.y) + stallStandoff;
            float cx = anchor.centre.x, cz = anchor.centre.z;

            float dx = Mathf.Abs(from.x - cx), dz = Mathf.Abs(from.z - cz);

            if (dx < halfX && dz < halfZ)
            {
                // standing inside the expanded footprint: push out along the shallower axis
                float penX = halfX - dx, penZ = halfZ - dz;
                if (penX < penZ)
                {
                    float signX = (from.x - cx) >= 0f ? 1f : -1f;
                    return new Vector3(cx + signX * halfX, from.y, from.z);
                }

                float signZ = (from.z - cz) >= 0f ? 1f : -1f;
                return new Vector3(from.x, from.y, cz + signZ * halfZ);
            }

            return new Vector3(Mathf.Clamp(from.x, cx - halfX, cx + halfX), from.y,
                               Mathf.Clamp(from.z, cz - halfZ, cz + halfZ));
        }

        private static Vector3 ClosestPointOnFootprint(Vector3 from, StallAnchor anchor)
        {
            return new Vector3(
                Mathf.Clamp(from.x, anchor.centre.x - Mathf.Abs(anchor.halfExtents.x),
                                     anchor.centre.x + Mathf.Abs(anchor.halfExtents.x)),
                from.y,
                Mathf.Clamp(from.z, anchor.centre.z - Mathf.Abs(anchor.halfExtents.y),
                                     anchor.centre.z + Mathf.Abs(anchor.halfExtents.y)));
        }

        private static float PathLength(NavMeshPath path)
        {
            float total = 0f;
            Vector3[] corners = path.corners;
            for (int i = 1; i < corners.Length; i++)
                total += Vector3.Distance(corners[i - 1], corners[i]);
            return total;
        }

        private void FaceTowards(Vector3 target)
        {
            Vector3 dir = target - transform.position;
            dir.y = 0f;
            if (dir.sqrMagnitude < 0.0001f) return;

            Quaternion want = Quaternion.LookRotation(dir.normalized, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(
                transform.rotation, want, stallTurnSpeedDegPerSec * Time.deltaTime);
        }

        private void SetStallParams(bool interacting, bool talking)
        {
            if (!_stallCapable || _animator == null) return;
            _animator.SetBool(_atStallHash, interacting);
            _animator.SetBool(_talkingHash, talking);
        }

        private static bool HasBoolParameter(Animator animator, string parameterName)
        {
            if (animator == null || string.IsNullOrEmpty(parameterName)) return false;

            AnimatorControllerParameter[] parameters = animator.parameters;
            for (int i = 0; i < parameters.Length; i++)
            {
                if (parameters[i].type == AnimatorControllerParameterType.Bool &&
                    parameters[i].name == parameterName)
                    return true;
            }
            return false;
        }

        // ------------------------------------------------------------------ social conversation

        /// <summary>A villager is only available for a chat while idle on the street: not stalling,
        /// not already talking and not inside the post-conversation cooldown.</summary>
        private bool IsFreeForSocial()
        {
            // _stallCapable is the controller-introspection gate: true only when the Animator declares
            // both interaction bools, which is exactly what a conversation drives.
            if (!_ready || !_stallCapable) return false;
            if (_socialPhase != SocialPhase.None) return false;
            if (_stallPhase != StallPhase.None) return false;
            if (_socialCooldownTimer > 0f) return false;
            if (_agent == null || !_agent.isActiveAndEnabled || !_agent.isOnNavMesh) return false;
            return true;
        }

        /// <summary>Nearest free villager inside the scan radius, or null.</summary>
        private TownVillagerPatrol FindFreeNeighbour()
        {
            TownVillagerPatrol best = null;
            float bestSqrDistance = socialRadius * socialRadius;

            for (int i = ActiveVillagers.Count - 1; i >= 0; i--)
            {
                TownVillagerPatrol other = ActiveVillagers[i];

                // also drops entries left behind by villagers torn down without OnDisable
                if (other == null)
                {
                    ActiveVillagers.RemoveAt(i);
                    continue;
                }

                if (other == this) continue;
                if (!other.IsFreeForSocial()) continue;

                float sqrDistance = (other.transform.position - transform.position).sqrMagnitude;
                if (sqrDistance > bestSqrDistance) continue;

                bestSqrDistance = sqrDistance;
                best = other;
            }

            return best;
        }

        /// <summary>Rolls the conversation chance and, on a pass, completes the handshake with the neighbour.</summary>
        private bool TryBeginSocialConversation()
        {
            if (!_stallCapable || socialChancePercentage <= 0f) return false;
            if (!IsFreeForSocial()) return false;

            TownVillagerPatrol partner = FindFreeNeighbour();
            if (partner == null) return false;

            if (Random.Range(0f, 100f) >= socialChancePercentage) return false;

            // one shared duration keeps both sides talking for exactly as long
            float duration = Random.Range(socialTalkMin, socialTalkMax);
            if (!partner.AcceptSocialConversation(this, duration)) return false;

            BeginSocialConversation(partner, duration);
            return true;
        }

        /// <summary>Partner half of the handshake: re-checks its own availability before committing.</summary>
        private bool AcceptSocialConversation(TownVillagerPatrol initiator, float duration)
        {
            if (initiator == null) return false;
            if (!IsFreeForSocial()) return false;

            BeginSocialConversation(initiator, duration);
            return true;
        }

        private void BeginSocialConversation(TownVillagerPatrol partner, float duration)
        {
            _socialPhase = SocialPhase.Engaged;
            _socialPartner = partner;
            _socialTimer = duration;

            // Stop without ResetPath so the broad route resumes exactly where it was interrupted.
            _socialSavedSpeed = _agent.speed;
            _agent.speed = 0f;
            _agent.isStopped = true;
            _agent.updateRotation = false;

            SetStallParams(false, true);
        }

        private void UpdateSocialConversation()
        {
            // the partner was destroyed mid-conversation: stop rather than face a dead transform
            if (_socialPartner == null)
            {
                EndSocialConversation();
                return;
            }

            Vector3 toPartner = _socialPartner.transform.position - transform.position;
            toPartner.y = 0f;

            if (toPartner.sqrMagnitude > 0.0001f)
            {
                Quaternion want = Quaternion.LookRotation(toPartner.normalized, Vector3.up);
                float blend = 1f - Mathf.Exp(-socialTurnSmoothRate * Time.deltaTime);
                transform.rotation = Quaternion.Slerp(transform.rotation, want, blend);
            }

            _socialTimer -= Time.deltaTime;
            if (_socialTimer <= 0f)
                EndSocialConversation();
        }

        private void EndSocialConversation()
        {
            SetStallParams(false, false);

            _socialPhase = SocialPhase.None;
            _socialPartner = null;
            _socialTimer = 0f;
            _socialCooldownTimer = socialCooldownSeconds;
            _socialScanTimer = socialScanInterval;

            if (_agent == null) return;

            _agent.updateRotation = _defaultUpdateRotation;
            _agent.speed = _socialSavedSpeed > 0f ? _socialSavedSpeed : walkSpeed;
            if (_agent.isOnNavMesh) _agent.isStopped = _isWaiting;
        }

        // ------------------------------------------------------------------ agent / route helpers

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
            // Grounding: the baked NavMesh floats above the road strip, so a zero offset embeds the feet.
            _agent.baseOffset = groundOffset;

            // Restrict the agent to the Town_Street area so it stays on the cobblestone roads.
            int townStreetArea = NavMesh.GetAreaFromName(TownStreetAreaName);
            if (townStreetArea < 0)
            {
                Debug.LogWarning(
                    $"[{nameof(TownVillagerPatrol)}] NavMesh area '{TownStreetAreaName}' is not registered in " +
                    $"Project Settings > Navigation > Areas; falling back to slot {TownStreetAreaIndex}.",
                    this);
                townStreetArea = TownStreetAreaIndex;
            }

            _agent.areaMask = 1 << townStreetArea;
        }

        public void SnapToNavMesh()
        {
            if (_agent == null) _agent = GetComponent<NavMeshAgent>();
            if (_agent == null || !_agent.enabled) return;

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
            int mask = _agent != null ? _agent.areaMask : (1 << TownStreetAreaIndex);

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
            _arrivalResolved = false;

            if (waypoints == null || waypoints.Count == 0 || _agent == null || !_agent.isOnNavMesh)
                return;

            _currentWaypointIndex = Mathf.Clamp(_currentWaypointIndex, 0, waypoints.Count - 1);

            Vector3 target = waypoints[_currentWaypointIndex];
            // Clamp the destination to the road surface. SetDestination projects the target onto the NavMesh
            // regardless of its Y, so this normalises the destination data rather than the agent's height;
            // groundOffset is what actually sits the feet on the road.
            target.y = TownStreetGroundY;
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
            if (marketplaceStalls != null)
            {
                Gizmos.color = new Color(0.2f, 0.9f, 1f, 0.6f);
                for (int i = 0; i < marketplaceStalls.Count; i++)
                {
                    StallAnchor a = marketplaceStalls[i];
                    Gizmos.DrawWireCube(
                        new Vector3(a.centre.x, a.centre.y, a.centre.z),
                        new Vector3(Mathf.Abs(a.halfExtents.x) * 2f + stallStandoff * 2f, 0.1f,
                                    Mathf.Abs(a.halfExtents.y) * 2f + stallStandoff * 2f));
                }
            }

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
            Debug.Log($"[TownVillagerPatrol] Agent '{name}': Speed={walkSpeed}, " +
                      $"AreaMask={(_agent != null ? _agent.areaMask : -1)}, Waypoints={(waypoints != null ? waypoints.Count : 0)}, " +
                      $"StallChance={stallChancePercentage}%, Stalls={(marketplaceStalls != null ? marketplaceStalls.Count : 0)}, " +
                      $"Phase={_stallPhase}");
        }
    }
}
