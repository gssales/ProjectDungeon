class_name Steering extends Spatial

var wall_avoidance := WallAvoidance.new()
var current_behavior: BaseSteeringBehavior

var wall_weight = 0.8
var steer_weight = 0.2

var entity: Entity

func _ready():
  entity = get_parent()
  
func calculate(delta, params):
  var result = Vector3.ZERO
  
  result += wall_avoidance._calculate(entity, delta, params) * wall_weight
    
  if current_behavior != null:
    result += current_behavior._calculate(entity, delta, params) * steer_weight
    
  if result.length() >= entity.max_force:
    result = result.normalized() * entity.max_force
  return result
  
func on_change_steering_behavior(behavior: BaseSteeringBehavior) -> void:
  current_behavior = behavior
