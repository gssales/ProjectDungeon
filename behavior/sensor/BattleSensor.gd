class_name BattleSensor extends Sensor

signal battle_state(battle_state)

var rng = RandomNumberGenerator.new()
var initiated = false
var prob_variance = 0
var time_to_update_variance = 10

func update(delta: float) -> void:
  if not initiated:
    rng.randomize()
    initiated = true
    
  time_to_update_variance += delta
  if time_to_update_variance >= 1:
    time_to_update_variance = 0
    # gera uma variancia para adicionar a prob de ataques
    # 5% de chance de avaliar errado o inimigo
    prob_variance = 1 if rng.randf() < 0.05 else 0
    
func _on_LineOfSight_update_closest_entity(entity):
  if entity != null and is_instance_valid(entity):
    var position = entity.global_transform.origin
    var speed = entity._velocity.length()
    var prob_attack = (1 - prob_variance) if entity.can_attack else (0 + prob_variance)
    emit_signal("battle_state", {
      'foe_position': position, 
      'foe_speed': speed,
      'foe_prob_attack': prob_attack
      })
  else:
    emit_signal("battle_state", null)
