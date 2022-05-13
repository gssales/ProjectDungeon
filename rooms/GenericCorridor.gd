extends Spatial

export var portal_up = false
export var portal_left = false
export var portal_down = false
export var portal_right = false

var Wall = preload("res://rooms/building/Wall.tscn")
var Floor = preload("res://rooms/building/Floor.tscn")

func add_wall(transl, rotat, length):
    var wall = Wall.instance()
    wall.translation = transl
    wall.length = length
    wall.rotate_y(deg2rad(rotat))
    wall.height = 5.5
    wall.depth = 2
    $Walls.add_child(wall)
  
func add_floor(transl, length, depth):
    var floor_ = Floor.instance()
    floor_.translation = transl
    floor_.length = length
    floor_.depth = depth
    add_child(floor_)

    
func _ready():
  if portal_up:
    add_floor(Vector3(0, 0, -11), 8, 14)
    add_wall(Vector3(-4, 0, -18), -90, 15)
    add_wall(Vector3(4, 0, -18), -90, 15)
  else:
    add_wall(Vector3(-5, 0, -4), 0, 10)
    
  if portal_down:
    add_floor(Vector3(0, 0, 11), 8, 14)
    add_wall(Vector3(-4, 0, 18), 90, 15)
    add_wall(Vector3(4, 0, 18), 90, 15)
  else:
    add_wall(Vector3(-5, 0, 4), 0, 10)
    
  if portal_right:
    add_floor(Vector3(11, 0, 0), 14, 8)
    add_wall(Vector3(18, 0, -4), 180, 13)
    add_wall(Vector3(18, 0, 4), 180, 13)
  else:
    add_wall(Vector3(4, 0, -3), -90, 6)
    
  if portal_left:
    add_floor(Vector3(-11, 0, 0), 14, 8)
    add_wall(Vector3(-18, 0, -4), 0, 13)
    add_wall(Vector3(-18, 0, 4), 0, 13)
  else:
    add_wall(Vector3(-4, 0, -3), -90, 6)

