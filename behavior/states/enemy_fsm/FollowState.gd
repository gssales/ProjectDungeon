class_name FollowState extends BaseState

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
  if entity.line_of_sight_state.foe_on_sight:
    emit_signal("change_entity", { 'steering_params_target': entity.line_of_sight_state.foe_position})
    
  # vá na direção do inimigo
  if entity.line_of_sight_state.distance_to_foe < 5:
    emit_signal("change_steering", ArriveSteering.new())
  else:
    emit_signal("change_steering", SeekSteering.new())
    
  # se estiver perto o sufiente vá pro modo ataque
  if entity.line_of_sight_state.distance_to_foe <= 2:
    var AttackState = load("res://behavior/states/enemy_fsm/EnemyAttackState.gd")
    emit_signal("change_state", AttackState.new())
  
  # se perder o inimigo de vista, continua indo até o ultimo ponto em que viu o inimigo e entra em modo lookout
  if not entity.line_of_sight_state.foe_on_sight:
    time_elapsed_interest += delta    
  else:
    time_elapsed_interest = 0
    
  if time_elapsed_interest >= time_before_loosing_interest:
    var LookOutState = load("res://behavior/states/enemy_fsm/LookOutState.gd")
    emit_signal("change_state", LookOutState.new())
  
func _exit(_entity: Entity):
  pass
