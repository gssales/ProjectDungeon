class_name Steering extends Spatial

var wall_avoidance := WallAvoidance.new()
var current_behavior: BaseSteeringBehavior

var wall_weight = 4
var steer_weight = 2

var entity: Entity

func _ready():
  entity = get_parent()
  
func calculate(delta, params):
  var result = Vector3.ZERO
  
  result += wall_avoidance._calculate(entity, delta, params) *  entity._velocity.length()
    
  if current_behavior != null:
    result += current_behavior._calculate(entity, delta, params) * steer_weight
    
  if result.length() >= entity.max_force:
    result = result.normalized() * entity.max_force
  return result
  
func _on_BehaviorState_change_steering(behavior: BaseSteeringBehavior) -> void:
  current_behavior = behavior
