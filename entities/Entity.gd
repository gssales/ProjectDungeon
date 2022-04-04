class_name Entity extends KinematicBody

var max_speed = 2
var max_force = 10
var max_turn_rate = PI/3

var _velocity := Vector3.ZERO
var _heading := Vector3.FORWARD

var do_rotate = false
var rotation_rad = 0
var rotated_rad = 0

var offset_heading = 0

var go_to_leader = false

func get_position() -> Vector3:
  return global_transform.origin

func _on_BehaviorState_change_entity(params):
  if params.has("max_speed"):
    max_speed = params.max_speed
  if params.has("max_force"):
    max_force = params.max_force
  if params.has("offset_heading"):
    offset_heading = params.offset_heading
  if params.has("go_to_leader"):
    go_to_leader = params.go_to_leader
    
func _on_LookOutState_entity_rotate(radians):
  rotation_rad = radians
  rotated_rad = 0
  do_rotate = true
