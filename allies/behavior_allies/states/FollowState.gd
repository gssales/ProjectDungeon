class_name FollowState_Ally extends BaseState_Ally

var SeekSteering
var ArriveSteering

var vision: LineOfSight_Ally
var steer_node: Steering_Ally
var time_before_loosing_interest = 8
var time_elapsed_interest = 0

func _enter(entity: Ally):
  SeekSteering = load("res://allies/behavior_allies/steering/SeekSteering.gd")
  ArriveSteering = load("res://allies/behavior_allies/steering/ArriveSteering.gd")
  
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  
  entity.max_speed = 17
  steer_node.current_behavior = SeekSteering.new()
  
func _execute(entity: Ally, delta: float):
  # vá na direção do inimigo
  var distance_to_foe = entity.transform.origin.distance_to(steer_node.target_position)
  if distance_to_foe < 5:
    steer_node.current_behavior = ArriveSteering.new()
  else:
    steer_node.current_behavior = SeekSteering.new()
    
  # se estiver perto o sufiente vá pro modo ataque
  if distance_to_foe <= 2:
    var behavior = entity.get_node("Behavior")
    var AttackState = load("res://allies/behavior_allies/states/AttackState.gd")
    behavior.change_state(AttackState.new())
  
  # se perder o inimigo de vista, continua indo até o ultimo ponto em que viu o inimigo e entra em modo lookout
  var seen = vision._look()
  if seen == null:
    entity.target_foe = null
    time_elapsed_interest += delta    
  else:
    entity.target_foe = seen
    time_elapsed_interest = 0
    
  if time_elapsed_interest >= time_before_loosing_interest:
    var behavior = entity.get_node("Behavior")
    var LookOutState = load("res://allies/behavior_allies/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())
  
func _exit(entity: Ally):
  pass
