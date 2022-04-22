extends Control

func _ready():
  self.visible = false
  #$Panel/VBoxContainer/ResumeBTN.grab_focus()

func _input(event):
  if event is InputEventKey:
    if event.is_action_pressed("pause_menu"):
      toggle_pause_menu()
      $Panel/VBoxContainer/ResumeBTN.grab_focus()
      get_tree().paused = not get_tree().paused

func toggle_pause_menu():
  self.visible = not self.visible

func _on_ResumeBTN_pressed():
  toggle_pause_menu()
  get_tree().paused = false


func _on_MainMenuBTN_pressed():
  toggle_pause_menu()
  get_tree().paused = false
  get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")


func _on_Quit_pressed():
  get_tree().quit()
