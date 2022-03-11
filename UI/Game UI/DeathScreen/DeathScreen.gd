extends CanvasLayer

func _ready():
  pass  

func _on_Health_you_died():
  $Popup.popup()
  get_tree().paused = true #not get_tree().paused


func _on_Restart_pressed():
  #$Popup.popup()
  get_tree().paused = false
  print("Pressed")
  get_tree().reload_current_scene()


func _on_MainMenuBTN_pressed():
  get_tree().quit()
