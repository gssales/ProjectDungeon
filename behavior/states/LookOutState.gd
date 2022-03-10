class_name LookOutState extends BaseState

var steer_node: Steering
var vision: LineOfSight
var lookout_duration
var time_elapsed = 0

func _enter(entity: Enemy):
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  var StoppingSteering = load("res://behavior/steering/StoppingSteering.gd")
  steer_node.current_behavior = StoppingSteering.new()
  entity.max_speed = 20
  lookout_duration = rand_range(3, 5)
  
func _execute(entity: Enemy, delta: float):
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
    var FollowState = load("res://behavior/states/FollowState.gd")
    behavior.change_state(FollowState.new())
  
  # se não vai pro modo wander
  if time_elapsed >= lookout_duration:
    var behavior = entity.get_node("Behavior")
    var WanderState = load("res://behavior/states/WanderState.gd")
    behavior.change_state(WanderState.new())
  
func _exit(entity: Enemy):
  pass
