class_name FollowState extends BaseState

var SeekSteering
var ArriveSteering

var vision: LineOfSight
var steer_node: Steering
var time_before_loosing_interest = 8
var time_elapsed_interest = 0

func _enter(entity: Enemy):
  SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  ArriveSteering = load("res://behavior/steering/ArriveSteering.gd")
  
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  
  entity.max_speed = 17
  steer_node.current_behavior = SeekSteering.new()
  
func _execute(entity: Enemy, delta: float):
  # vá na direção do inimigo
  var distance_to_foe = entity.transform.origin.distance_to(steer_node.target_position)
  if distance_to_foe < 5:
    steer_node.current_behavior = ArriveSteering.new()
  else:
    steer_node.current_behavior = SeekSteering.new()
    
  # se estiver perto o sufiente vá pro modo ataque
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
    var LookOutState = load("res://behavior/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())
  
func _exit(entity: Enemy):
  pass
