class_name Ally extends KinematicBody

export(float) var maxhealth = 100
var health = 0

var mass = 1

var max_speed = 2
var max_turn_rate = PI/3

var _velocity = Vector3.ZERO
var _heading = Vector3.FORWARD

var target_foe = null

func _ready():
  $DetectGround.enabled = true
  health = maxhealth

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
    if target_foe != null:
      $Steering.target_position = target_foe.transform.origin
    var steering_force = $Steering.calculate(delta)
    # calculate acceleration
    var acceleration = steering_force / mass
    # velocity 
    _velocity += acceleration * delta
    
  if _velocity.length() > max_speed:
    _velocity = _velocity.normalized() * max_speed
    
  if _velocity.length() > 0.000001:
    _heading = Vector3(_velocity.x, 0, _velocity.z).normalized() * 4
    look_at(transform.origin + _heading, Vector3.UP)
    
  _velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector3.DOWN)

func take_damage(amount):
  health -= amount
  if health < 0:
    health = 0 
