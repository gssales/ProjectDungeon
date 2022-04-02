class_name FollowPlayerState_Ally extends BaseState_Ally

# include ally in players party when player interacts with ally
# change "default" state from WanderState / IdleState -> (invincible) to FollowPlayerState 
# get_tree().find_node("Player") or something with get_parent()
# use this to get player position 
# stick close to player (no matter the distance, get near player) -> until enemy seen
# if enemy seen -> FollowState 
# if no more enemies return to FollowPlayerState

# if dist > 2 => steer towards player

var SeekSteering
var ArriveSteering

var vision: LineOfSight_Ally
var steer_node: Steering_Ally
var party_pos
var party: Node = null
var player = null
var time_before_loosing_interest = 8
var time_elapsed_interest = 0

func _enter(entity: Ally):
  SeekSteering = load("res://allies/behavior_allies/steering/SeekSteering.gd")
  ArriveSteering = load("res://allies/behavior_allies/steering/ArriveSteering.gd")
  
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  party_pos = entity.get_node("PartyPosition")
  party = entity.get_parent()
  player = party.get_parent()
  
  entity.max_speed = 17
  steer_node.current_behavior = SeekSteering.new()
  
func _execute(entity: Ally, delta: float):
  #if entity.target_foe != null and (not entity.target_foe.is_in_group("player")):
    
  var leader = party_pos._look_for_leader()
  entity.target_foe = leader

  # vá na direção do inimigo
  var distance_to_foe = entity.transform.origin.distance_to(steer_node.target_position)
  if distance_to_foe < 5:
    steer_node.current_behavior = BaseSteeringBehavior_Ally.new()#ArriveSteering.new()
    var behavior = entity.get_node("Behavior")
    var LookOutState = load("res://allies/behavior_allies/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())
  elif distance_to_foe < 10:
    steer_node.current_behavior = ArriveSteering.new()
  else:
    steer_node.current_behavior = SeekSteering.new()
    
  # se estiver perto o sufiente do jogador -> procurar inimigos / ver se há inimigos
#  if distance_to_foe <= 4:
#    var behavior = entity.get_node("Behavior")
#    var LookOutState = load("res://allies/behavior_allies/states/LookOutState.gd")
#    behavior.change_state(LookOutState.new())
#    var AttackState = load("res://allies/behavior_allies/states/AttackState.gd")
#    behavior.change_state(AttackState.new())
  
  # se perder o inimigo de vista, continua indo até o ultimo ponto em que viu o inimigo e entra em modo lookout
#  var leader = party_pos._look_for_leader()
#  if leader == null:
#    entity.target_foe = null
#    time_elapsed_interest += delta    
#  else:
#  entity.target_foe = leader
#    time_elapsed_interest = 0
    
#  if time_elapsed_interest >= time_before_loosing_interest:
#    var behavior = entity.get_node("Behavior")
#    var LookOutState = load("res://allies/behavior_allies/states/LookOutState.gd")
#    behavior.change_state(LookOutState.new())
  
func _exit(entity: Ally):
  pass
