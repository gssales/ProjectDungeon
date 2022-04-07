extends Spatial

export var portal_up = false
export var portal_left = false
export var portal_down = false
export var portal_right = false

var Wall = preload("res://rooms/building/Wall.tscn")

func add_wall(transl, rotat, length):
    var wall = Wall.instance()
    wall.translation = transl
    wall.length = length
    wall.rotate_y(deg2rad(rotat))
    wall.height = 5.5
    wall.depth = 2
    $Walls.add_child(wall)

func _ready():
  if portal_up:
    add_wall(Vector3(-16, 0, -17), 0, 13)
    add_wall(Vector3(3, 0, -17), 0, 13)
  else:
    add_wall(Vector3(-16, 0, -17), 0, 32)
    
  if portal_down:
    add_wall(Vector3(-3, 0, 17), 180, 13)
    add_wall(Vector3(16, 0, 17), 180, 13)
  else:
    add_wall(Vector3(16, 0, 17), 180, 32)
    
  if portal_right:
    add_wall(Vector3(17, 0, -18), -90, 15)
    add_wall(Vector3(17, 0, 18), 90, 15)
  else:
    add_wall(Vector3(17, 0, 18), 90, 36)
    
  if portal_left:
    add_wall(Vector3(-17, 0, -18), -90, 15)
    add_wall(Vector3(-17, 0, 18), 90, 15)
  else:
    add_wall(Vector3(-17, 0, 18), 90, 36)
