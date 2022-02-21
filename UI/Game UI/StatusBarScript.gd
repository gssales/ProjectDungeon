extends HBoxContainer

var maximum_value = 100

func set_max_value(maximum):
  maximum_value = maximum
  $TextureProgress.max_value = maximum

func _on_GameUI_NEW_stamina_changed(stamina):
  $TextureProgress.value = stamina
  $Counter/Label.text = "%s/%s" % [stamina, maximum_value]
