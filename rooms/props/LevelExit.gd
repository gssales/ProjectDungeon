extends Spatial

var _show_tooltip = false

func _physics_process(delta):
  var player
  
  if get_tree().get_nodes_in_group("player").size() > 0:
    player = get_tree().get_nodes_in_group("player")[0]
    show_tooltip(
      global_transform.origin.distance_squared_to(
        player.global_transform.origin) 
      <= 10)
  else:
    return
      
  if _show_tooltip and Input.is_action_just_pressed("interact"):
    Global.current_level += 1
    Global.load_player = true
    Global.player = player
    Global.allies = get_tree().get_nodes_in_group("allies")
    get_tree().change_scene("res://Generation.tscn")

func show_tooltip(show):
  _show_tooltip = show
  $Tooltip.visible = show
