class_name Steering extends Spatial
enum { SEEK, ARRIVE, WANDER }

var current_behavior: BaseSteeringBehavior

var parent
var target_position = Vector3.ZERO

func _ready():
  parent = get_parent()
  
func calculate(delta):
  var result = Vector3.ZERO
  if current_behavior != null:
    result = current_behavior._calculate(parent, delta, { target= target_position })      
  return result
