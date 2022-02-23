extends Control

func _ready():
  self.visible = false

func _input(event):
  if event is InputEventKey:
    if event.is_action_pressed("pause_menu"):
      toggle_pause_menu()
      get_tree().paused = not get_tree().paused

func toggle_pause_menu():
  self.visible = not self.visible

#func _on_Player_toggle_pause_menu():
#  self.visible = not self.visible


func _on_ResumeBTN_pressed():
  toggle_pause_menu()
  get_tree().paused = false
