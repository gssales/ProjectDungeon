class_name Entity extends KinematicBody

var max_speed = 2
var max_force = 1
var max_turn_rate = PI/3

var _velocity = Vector3.ZERO
var _heading = Vector3.FORWARD

func get_position() -> Vector3:
  return global_transform.origin
