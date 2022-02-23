extends Control

signal stamina_changed(stamina)
signal health_changed(health)

func _on_Stamina_stamina_changed(new_stamina):
  emit_signal("stamina_changed", new_stamina)


func _on_Health_health_changed(new_health):
  emit_signal("health_changed", new_health)
