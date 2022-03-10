class_name WanderState extends BaseState

var steer_node: Steering
var vision: LineOfSight
var wandering_duration
var time_elapsed = 0

func _enter(entity: Enemy):
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  var WanderSteering = load("res://behavior/steering/WanderSteering.gd")
  steer_node.current_behavior = WanderSteering.new()
  entity.max_speed = 5
  wandering_duration = rand_range(3, 5)

func _execute(entity: Enemy, delta: float):
  # vaga aleatoriamente por X segundos
  time_elapsed += delta
  
  # se ver um inimigo, vai pro modo seguir
  var seen = vision._look()
  if seen != null:
    entity.target_foe = seen
    
    var behavior = entity.get_node("Behavior")
    var FollowState = load("res://behavior/states/FollowState.gd")
    behavior.change_state(FollowState.new())
  
  # senao muda para o modo lookout
  if time_elapsed >= wandering_duration:
    var behavior = entity.get_node("Behavior")
    var LookOutState = load("res://behavior/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())

func _exit(entity: Enemy):
  pass
