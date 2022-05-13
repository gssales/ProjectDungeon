extends Control



func _ready():
  $panel/ButtonContainer/New_game.grab_focus()

# Start the game
func _on_New_game_pressed():
  Global.current_level = 0
  get_tree().change_scene("res://Generation.tscn")

# Exit game
func _on_Quit_pressed():
  get_tree().quit()
