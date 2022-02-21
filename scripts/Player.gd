extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var GRAVITY = 980
export var max_speed = 20
export var acceleration = 15

var _velocity = Vector3.ZERO
var angle = 0
var speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  $Camera.look_at(self.transform.origin, Vector3.UP)

func _physics_process(delta):
  var move_vec = Vector3()
  if Input.is_action_pressed("move_forward"):
    move_vec += Vector3.FORWARD
  if Input.is_action_pressed("move_left"):
    move_vec += Vector3.LEFT
  if Input.is_action_pressed("move_backward"):
    move_vec += Vector3.BACK
  if Input.is_action_pressed("move_right"):
    move_vec += Vector3.RIGHT

  move_vec = move_vec.normalized()

  if move_vec.length() > 0 :
    var new_yaw = atan2(move_vec.x, move_vec.z) # 0,2*PI
    var rot = Quat(Vector3(0.0, new_yaw, 0.0))
    var t = Quat($Model.transform.basis)
    var interp = t.slerp(rot, 0.2)
    $Model.transform.basis = Basis(interp)

    speed = min(speed + acceleration * delta, max_speed)
  else:
    speed = max(speed - acceleration * delta, 0) 

  if Input.is_action_pressed("sprint"):
      move_vec *= speed*1.5
  else:
    move_vec *= speed

  if not $DetectGround.is_colliding():
    move_vec += Vector3.DOWN * GRAVITY * delta

  _velocity = move_vec

  _velocity = move_and_slide_with_snap(_velocity, Vector3.DOWN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
