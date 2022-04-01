class_name FollowState extends BaseState

const FOLLOW_STATE = "follow_state"

var SeekSteering
var ArriveSteering

var time_before_loosing_interest = 8
var time_elapsed_interest = 0

func _enter(_entity: Entity):
  SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  ArriveSteering = load("res://behavior/steering/ArriveSteering.gd")
  
  emit_signal("change_steering", SeekSteering.new())
  emit_signal("change_entity", { 'max_speed': 17 })
    
func _execute(entity: Entity, delta: float):
  # vá na direção do inimigo
  if entity.distance_to_target < 5:
    emit_signal("change_steering", ArriveSteering.new())
  else:
    emit_signal("change_steering", SeekSteering.new())
    
  # se estiver perto o sufiente vá pro modo ataque
  if entity.distance_to_target <= 2:
    var AttackState = load("res://behavior/states/AttackState.gd")
    emit_signal("change_state", AttackState.new())
  
  # se perder o inimigo de vista, continua indo até o ultimo ponto em que viu o inimigo e entra em modo lookout
  if not entity.target_on_sight:
    time_elapsed_interest += delta    
  else:
    time_elapsed_interest = 0
    
  if time_elapsed_interest >= time_before_loosing_interest:
    var LookOutState = load("res://behavior/states/LookOutState.gd")
    emit_signal("change_state", LookOutState.new())
  
