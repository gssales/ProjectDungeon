extends Spatial

signal go_to_next_level(player)

var _show_tooltip = false

var node = null # Generated (the node that contains the map generated)

func _ready():
  #node = get_tree().get_root().find_node("LevelGeneration")
  #node = find_parent("LevelGeneration")
  node = get_parent().get_parent() # ver se não tem uma maneira melhor de achar esse nodo
  connect("go_to_next_level", node, "on_LevelExit_go_to_next_level")


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
    #get_tree().change_scene("res://Generation.tscn")
    
    #print(Global.player)
    if is_connected("go_to_next_level", node, "on_LevelExit_go_to_next_level"):
      emit_signal("go_to_next_level", player)
      disconnect("go_to_next_level", node, "on_LevelExit_go_to_next_level")

func show_tooltip(show):
  _show_tooltip = show
  $Tooltip.visible = show
