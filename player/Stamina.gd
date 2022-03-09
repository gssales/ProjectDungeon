extends Node


signal stamina_changed(new_stamina)

var stamina = 0
export(float) var max_stamina = 100

func _ready():
  stamina = max_stamina
  emit_signal("stamina_changed", max_stamina)
  #emit a signal to the StaminaBar to set its max value correctly aswell

func get_stamina():
  return stamina

func use_stamina(amount):
  stamina -= amount
  if stamina < 0:
    stamina = 0 
    #print("Stamina already depleted")
  
  emit_signal("stamina_changed", stamina)
  #print("Signal emmited")

func regen_stamina(amount):
  stamina += amount
  if stamina > max_stamina:
    stamina = max_stamina 
    #print("Stamina already full")
  
  emit_signal("stamina_changed", stamina)
  #print("Signal emmited")
