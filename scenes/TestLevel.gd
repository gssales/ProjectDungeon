extends Spatial

func _ready():
  var fogs = get_tree().get_nodes_in_group("fog_of_war")
  for fog in fogs:
    $Player.connect("position_changed", fog, "_on_Player_position_changed")
