class_name LookOutState_Ally extends BaseState_Ally

var steer_node: Steering_Ally
var vision: LineOfSight_Ally
var lookout_duration
var time_elapsed = 0

func _enter(entity: Ally):
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  var StoppingSteering = load("res://allies/behavior_allies/steering/StoppingSteering.gd")
  steer_node.current_behavior = StoppingSteering.new()
  entity.max_speed = 20
  lookout_duration = rand_range(3, 5)
  
func _execute(entity: Ally, delta: float):
  if entity._velocity.length() > 0.05:
    return
  entity._velocity = Vector3.ZERO
  
  # Olha ao redor por x segundos
  time_elapsed += delta
  # Se ver o jogador entra no modo seek
  var seen = vision._look()
  if seen != null:
    entity.target_foe = seen
    
    var behavior = entity.get_node("Behavior")
    var FollowState = load("res://allies/behavior_allies/states/FollowState.gd")
    behavior.change_state(FollowState.new())
  
  # se não vai pro modo FollowPlayer
  if time_elapsed >= lookout_duration:
    var behavior = entity.get_node("Behavior")
    var FollowPlayerState = load("res://allies/behavior_allies/states/FollowPlayerState.gd")
    behavior.change_state(FollowPlayerState.new())
  
func _exit(entity: Ally):
  pass
