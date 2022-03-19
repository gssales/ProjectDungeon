class_name Steering_Ally extends Spatial
enum { SEEK, ARRIVE, WANDER }

var current_behavior: BaseSteeringBehavior_Ally

var parent
var target_position = Vector3.ZERO

func _ready():
  parent = get_parent()
  
func calculate(delta):
  var result = Vector3.ZERO
  if current_behavior != null:
    result = current_behavior._calculate(parent, delta, { target= target_position })      
  return result
