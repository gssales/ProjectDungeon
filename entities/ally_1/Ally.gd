class_name Ally extends Entity

export(float) var maxhealth = 100
var health = 0

var mass = 1
var steering_params = {}

var target_on_sight = false
var distance_to_target = 1e10

var distance_from_leader = 1e10

var battle_state = null

var can_attack = false
var added_to_party = false

func _ready():
  max_speed = 2
  max_turn_rate = PI/3
  _velocity = Vector3.ZERO
  _heading = Vector3.FORWARD
  $DetectGround.enabled = true
  health = maxhealth
  
  #warning-ignore-all:return_value_discarded
  $WallSensor.connect("wall_detected", self, "_on_WallSensor_wall_detected")
  $LineOfSight.looking_for_groups.push_back("enemy")
  $LineOfSight.connect("update_closest_entity", self, "_on_LineOfSight_update_closest_entity")
  $LineOfSight.connect("update_closest_entity", $BattleSensor, "_on_LineOfSight_update_closest_entity")
  $BattleSensor.connect("battle_state", self, "_on_BattleSensor_battle_state")
  $LeaderSensor.connect("leader_position_changed", self, "_on_LeaderSensor_leader_position_changed")
  
  var IdleState = load("res://behavior/states/ally_fsm/IdleState.gd")
  $Behavior._on_BehaviorState_change_state(IdleState.new())
  
  set_as_toplevel(true)

func _physics_process(delta):
  if health <= 0:
    queue_free()
  
  $Behavior.update(delta)
  
  var snap_vector = Vector3.DOWN
  
  if not $DetectGround.is_colliding():
    _velocity += Vector3.DOWN * 9.88 * delta
  else:
    snap_vector = -$DetectGround.get_collision_normal()
    # calculate force
    var steering_force = $Steering.calculate(delta, steering_params)
    # calculate acceleration
    var acceleration = steering_force / mass
    # velocity 
    _velocity += acceleration * delta
    
  if _velocity.length() > max_speed:
    _velocity = _velocity.normalized() * max_speed
    
  if Vector2(_velocity.x, _velocity.z).length() > 0.000001:
    _heading = Vector3(_velocity.x, 0, _velocity.z).normalized() * 4
    if offset_heading != 0:
      _heading = _heading.rotated(Vector3.UP, offset_heading)
    look_at(transform.origin + _heading, Vector3.UP)
    
  _velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector3.DOWN)

func take_damage(amount):
  health -= amount
  if health < 0:
    health = 0 
    
func _on_LineOfSight_update_closest_entity(entity):
  if entity != null:
    target_on_sight = true
    distance_to_target = get_position().distance_to(entity.global_transform.origin)
    if not go_to_leader:
      steering_params["target"] = entity.global_transform.origin
  else:
    target_on_sight = false
    distance_to_target = 1e10
    if not go_to_leader:
      steering_params["target"] = null

func _on_WallSensor_wall_detected(wall_detected):
  steering_params["wall_detected"] = wall_detected

func _on_BattleSensor_battle_state(new_battle_state):
  self.battle_state = new_battle_state
  
func _on_LeaderSensor_leader_position_changed(new_position):
  if new_position != null:
    distance_from_leader = global_transform.origin.distance_to(new_position)
  else:
    distance_from_leader = 1e10
  if go_to_leader:
    steering_params["target"] = new_position
  
func _on_PartyManager_tick_sensor(delta):
  $LineOfSight.update(delta)
  $WallSensor.update(delta)
  $BattleSensor.update(delta)
  $LeaderSensor.update(delta)
  
func _on_AttackState_entity_attack():
  pass

func add_to_party():
  added_to_party = true
  
func remove_from_party():
  added_to_party = false
  var IdleState = load("res://allies/behavior_allies/states/IdleState.gd").new()
  $Behavior.change_state(IdleState)

func is_in_party():
  return added_to_party
