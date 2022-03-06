extends Spatial

export(PackedScene) var hitbox
var hitbox_pos : Position3D

func _ready():
  hitbox_pos = get_node("hitbox_pos")
  if hitbox:
    hitbox_pos.add_child(hitbox.instance())
      
