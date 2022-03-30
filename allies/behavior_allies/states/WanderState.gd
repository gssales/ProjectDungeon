class_name WanderState_Ally extends BaseState_Ally

# Change this state to follow players around, 
# and if it detects an enemy goes to attack it (close or long range)

var steer_node: Steering_Ally
var vision: LineOfSight_Ally
var wandering_duration
var time_elapsed = 0

func _enter(entity: Ally):
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  var WanderSteering = load("res://allies/behavior_allies/steering/WanderSteering.gd")
  steer_node.current_behavior = WanderSteering.new()
  entity.max_speed = 5
  wandering_duration = rand_range(3, 5)

func _execute(entity: Ally, delta: float):
  # vaga aleatoriamente por X segundos
  time_elapsed += delta
  
  # se ver um inimigo, vai pro modo seguir
  var seen = vision._look()
  if seen != null:
    entity.target_foe = seen
    
    var behavior = entity.get_node("Behavior")
    var FollowState = load("res://allies/behavior_allies/states/FollowState.gd")
    behavior.change_state(FollowState.new())
  
  # senao muda para o modo lookout
  if time_elapsed >= wandering_duration:
    var behavior = entity.get_node("Behavior")
    var LookOutState = load("res://allies/behavior_allies/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())

func _exit(entity: Ally):
  pass