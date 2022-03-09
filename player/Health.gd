extends Node


signal health_changed(new_health)

var health = 100
export(float) var max_health = 100

func _ready():
  health = max_health
  emit_signal("health_changed", max_health)
  #emit a signal to the StaminaBar to set its max value correctly aswell

func get_health():
  return health

func take_damage(amount):
  health -= amount
  if health < 0:
    health = 0 
    #print("Health already depleted")
  
  emit_signal("health_changed", health)
  #print("Signal emmited")

func regen_health(amount):
  health += amount
  if health > max_health:
    health = max_health 
    #print("Health already full")
  
  emit_signal("health_changed", health)
