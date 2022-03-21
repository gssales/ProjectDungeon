class_name IdleState_Ally extends BaseState_Ally

# Change this state to make ally immortal and wait to be added to a party

var steer_node: Steering_Ally
var vision: LineOfSight_Ally
var wandering_duration
var time_elapsed = 0
var added_to_player_party = false

func _enter(entity: Ally):
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  var WanderSteering = load("res://allies/behavior_allies/steering/WanderSteering.gd")
  steer_node.current_behavior = WanderSteering.new()
  entity.max_speed = 0
  wandering_duration = rand_range(3, 5)

func _execute(entity: Ally, delta: float):
#  # vaga aleatoriamente por X segundos
#  time_elapsed += delta
#
#  # se ver um inimigo, vai pro modo seguir
#  var seen = vision._look()
#  if seen != null:
#    entity.target_foe = seen
#
#    var behavior = entity.get_node("Behavior")
#    var FollowState = load("res://allies/behavior_allies/states/FollowState.gd")
#    behavior.change_state(FollowState.new())
#
  # se adicionado a party do jogador muda para modo seguir jogador
  if added_to_player_party:
    var behavior = entity.get_node("Behavior")
    var FollowPlayerState = load("res://allies/behavior_allies/states/FollowPlayerState.gd")
    behavior.change_state(FollowPlayerState)
    
  # senao muda para o modo lookout
  if time_elapsed >= wandering_duration:
    var behavior = entity.get_node("Behavior")
    var LookOutState = load("res://allies/behavior_allies/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())

func _exit(entity: Ally):
  pass
