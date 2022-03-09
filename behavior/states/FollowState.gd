class_name FollowState
extends StateBehavior

func _enter(entity):
  pass
  
func _execute(entity):
  var steer_node = entity.get_node("Steering")
    
  var dist = (steer_node.target_position - entity.transform.origin).length_squared()
  
  if dist > 16:
    steer_node.active_behavior = steer_node.Behaviors.seek
  else:
    steer_node.active_behavior = steer_node.Behaviors.arrive
  
func _exit(entity):
  pass
