extends Node

enum Behaviors {
  seek,
  arrive
 }
var active_behavior = Behaviors.seek

var parent
var target_position = Vector3.ZERO

func _ready():
  parent = get_parent()
  
func calculate():
  var result = Vector3.ZERO
  
  if active_behavior == Behaviors.seek:
    result = seek(target_position)
  if active_behavior == Behaviors.arrive:
    result = arrive(target_position)
    
  return result
  
func seek(target):
  var desired_velocity = (target - get_parent().transform.origin).normalized() * get_parent().max_speed
  return desired_velocity - get_parent()._velocity
  
func arrive(target):
  var to_target = target - get_parent().transform.origin
  var distance = to_target.length()
  
  if distance > 1:
    var speed = distance / 0.9
    speed = min(speed, get_parent().max_speed)
    
    var desired_velocity = to_target * speed / distance
    return desired_velocity - get_parent()._velocity
  
  return Vector3.ZERO
  
func wander():
  pass
  
func flee():
  pass

func idle():
  pass
