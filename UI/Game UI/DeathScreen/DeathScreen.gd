extends CanvasLayer

func _ready():
  #$Popup/Panel/VBoxContainer/Restart.grab_focus()  
  pass 
  
func _on_Health_you_died():
  $Popup.popup()
  get_tree().paused = true #not get_tree().paused
  $Popup/Panel/VBoxContainer/Restart.grab_focus()


func _on_Restart_pressed():
  #$Popup.popup()
  get_tree().paused = false
  Global.current_level = 0
  #var _reloaded = get_tree().reload_current_scene()
  var _reloaded = get_tree().change_scene("res://Generation.tscn")


func _on_MainMenuBTN_pressed():
  get_tree().paused = false
  get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")


func _on_QuitBTN_pressed():
  get_tree().quit()
