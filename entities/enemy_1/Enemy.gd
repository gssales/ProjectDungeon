class_name Enemy extends Entity

export(float) var maxhealth = 35
var health = 0

var mass = 1
var steering_params = {}

var target_on_sight = false
var distance_to_target = 1e10

var can_attack = false

func _ready():
  max_speed = 2
  _velocity = Vector3.ZERO
  _heading = Vector3.FORWARD
  $DetectGround.enabled = true
  health = maxhealth
  
  #warning-ignore-all:return_value_discarded
  $WallSensor.connect("wall_detected", self, "_on_WallSensor_wall_detected")
  $LineOfSight.looking_for_groups.push_back("player")
  $LineOfSight.looking_for_groups.push_back("ally")
  $LineOfSight.connect("update_closest_entity", self, "_on_LineOfSight_update_closest_entity")
  
  var WanderState = load("res://behavior/states/enemy_fsm/WanderState.gd")
  $Behavior._on_BehaviorState_change_state(WanderState.new())

func _physics_process(delta):
  if health <= 0:
    queue_free()
    
  if do_rotate:
    var rot = (rotation_rad + rotated_rad) * delta * -1
    _heading = _heading.rotated(Vector3.UP, rot)
    look_at(transform.origin + _heading, Vector3.UP)
    
    rotated_rad += rot
    if abs(rotation_rad + rotated_rad) <= 0.001:
      do_rotate = false
    
  $LineOfSight.update(delta)
  $WallSensor.update(delta)
  
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
    steering_params["target"] = entity.global_transform.origin
  else:
    target_on_sight = false
    distance_to_target = 1e10

func _on_WallSensor_wall_detected(wall_detected):
  steering_params["wall_detected"] = wall_detected

func _on_AttackState_entity_attack():
  pass  
