class_name Ally extends Entity

export(float) var maxhealth = 100
var health = 0

var mass = 1

var line_of_sight_state = {
  "foe_on_sight": false,
  "distance_to_foe": 1e10,
  "foe_position": Vector3.ZERO
 }
var leader_state = {
  "leader_on_sight": false,
  "distance_from_leader": 1e10,
  "leader_position": Vector3.ZERO
}
var battle_state = null

var can_attack = false
var may_attack = false
var attk_timer
var attk_delay = 0.8
onready var attack_hitbox = $AttackHitbox/Area
export(float) var damage = 7

var added_to_party = false

func _ready():
  max_speed = 2
  max_turn_rate = PI/3
  _velocity = Vector3.ZERO
  _heading = Vector3.FORWARD
  $DetectGround.enabled = true
  health = maxhealth
  
  attk_timer = Timer.new() #attack timer
  add_child(attk_timer)
  attk_timer.one_shot = true
  attk_timer.wait_time = attk_delay
  
  #warning-ignore-all:return_value_discarded
  $WallSensor.connect("wall_detected", self, "_on_WallSensor_wall_detected")
  $LineOfSight.looking_for_groups.push_back("Enemy")
  $LineOfSight.connect("update_closest_entity", self, "_on_LineOfSight_update_closest_entity")
  $LineOfSight.connect("update_closest_entity", $BattleSensor, "_on_LineOfSight_update_closest_entity")
  $BattleSensor.connect("battle_state", self, "_on_BattleSensor_battle_state")
  $LeaderSensor.connect("leader_position_changed", self, "_on_LeaderSensor_leader_position_changed")
  
  var IdleState = load("res://behavior/states/ally_fsm/IdleState.gd")
  $Behavior._on_BehaviorState_change_state(IdleState.new())
  
  set_as_toplevel(true)

func _physics_process(delta):
  if health <= 0:
    die()
  
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
  
  # Ally attack
  if may_attack and attk_timer.is_stopped():
    for body in attack_hitbox.get_overlapping_bodies():
      if body.is_in_group("Enemy"):
        print("ally attaking enemy")
        body.take_damage(damage)
      
      attk_timer.start(attk_delay)

func die():
  var c = load("res://player/lw_polly_char.tscn")
  var body = c.instance()
  get_parent().add_child(body)
  body.transform = body.transform.scaled(Vector3(2,2,2)).rotated(Vector3.UP, PI +rotation.y)
  body.transform.origin = transform.origin
  body.body_sim()
  queue_free()
  
func take_damage(amount):
  if !$DamageSFX.is_playing():
    $DamageSFX.play()
  health -= amount
  if health < 0:
    health = 0 
    
func _on_LineOfSight_update_closest_entity(entity):
  if entity != null and is_instance_valid(entity):
    line_of_sight_state.foe_on_sight = true
    line_of_sight_state.distance_to_foe = get_position().distance_to(entity.global_transform.origin)
    line_of_sight_state.foe_position = entity.global_transform.origin
  else:
    line_of_sight_state.foe_on_sight = false
    line_of_sight_state.distance_to_foe = 1e10

func _on_WallSensor_wall_detected(wall_detected):
  steering_params["wall_detected"] = wall_detected

func _on_BattleSensor_battle_state(new_battle_state):
  self.battle_state = new_battle_state
  
func _on_LeaderSensor_leader_position_changed(state):
  if state.leader_on_sight:
    leader_state.leader_on_sight = true
    leader_state.distance_from_leader = global_transform.origin.distance_to(state.leader_position)
    leader_state.leader_position = state.leader_position
  else:
    leader_state.leader_on_sight = false
    leader_state.distance_from_leader = 1e10
    leader_state.leader_position = state.leader_position
  
func _on_PartyManager_tick_sensor(delta):
  $LineOfSight.update(delta)
  $WallSensor.update(delta)
  $BattleSensor.update(delta)
  $LeaderSensor.update(delta)
  
  
func _on_AttackState_entity_attack(entity):
  if entity == self:
    may_attack = true
    print(self, "can_attack")
    attk_timer.start(attk_delay) 

func _on_AttackState_entity_cannot_attack(entity):
  if entity == self:
    may_attack = false
    print(self, "cannot_attack")
    attk_timer.start(attk_delay)

func add_to_party():
  added_to_party = true
  #remove_from_group("free_ally")
  #add_to_group("ally")
  
func remove_from_party():
  added_to_party = false
  #remove_from_group("ally")
  #add_to_group("free_ally")
  var IdleState = load("res://allies/behavior_allies/states/IdleState.gd").new()
  $Behavior.change_state(IdleState)

func is_in_party():
  return added_to_party
