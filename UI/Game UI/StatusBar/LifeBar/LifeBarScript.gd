extends HBoxContainer

var maximum_value = 100

func set_max_value(maximum):
  maximum_value = maximum
  $TextureProgress.max_value = maximum

func _on_GameUI_NEW_health_changed(health):
  $TextureProgress.value = health
  $Counter/Label.text = "%s/%s" % [round(health), maximum_value]
