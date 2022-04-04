class_name LookOutState extends BaseState

signal entity_rotate(radians)

const LOOKOUT_STATE = "lookout_state"

var rng = RandomNumberGenerator.new()

var lookout_duration
var time_until_rotate
var time_elapsed = 0
var timer_rotate = 0

func _enter(entity: Entity):
  #warning-ignore-all:return_value_discarded
  connect("entity_rotate", entity, "_on_LookOutState_entity_rotate")
  
  rng.randomize()
  
  var StoppingSteering = load("res://behavior/steering/StoppingSteering.gd")
  emit_signal("change_steering", StoppingSteering.new())
  emit_signal("change_entity", { 'max_speed': 20 })
  
  lookout_duration = rng.randf_range(6, 8)
  time_until_rotate = rng.randf_range(2, 5)
  
  
func _execute(entity: Entity, delta: float):
  if entity._velocity.length() > 0.05:
    return
  entity._velocity = Vector3.ZERO
  
  # Olha ao redor por x segundos
  time_elapsed += delta
  timer_rotate += delta
  
  if timer_rotate >= time_until_rotate:
    timer_rotate = 0
    var rot = rand_range(-PI/3, PI/3)
    rot += PI/6 * rot/abs(rot)
    emit_signal("entity_rotate", rot)
    time_until_rotate = rng.randf_range(2, 5)
  
  # Se ver o jogador entra no modo seek
  if entity.target_on_sight:
    var FollowState = load("res://behavior/states/enemy_fsm/FollowState.gd")
    emit_signal("change_state", FollowState.new())
  
  # se não vai pro modo wander
  if time_elapsed >= lookout_duration:
    var WanderState = load("res://behavior/states/enemy_fsm/WanderState.gd")
    emit_signal("change_state", WanderState.new())


func _exit(entity: Entity):
  disconnect("entity_rotate", entity, "_on_LookOutState_entity_rotate")
