extends Node

var GenericRoom = preload("res://rooms/GenericRoom.tscn")
var GenericCorridor = preload("res://rooms/GenericCorridor.tscn")

var last_room = Vector2(0,0)

func generate(matrix, room_size: Vector2) -> Spatial:
  var size = matrix.size()
  var map = Spatial.new()
  for x in range(size):
    for y in range(size):
      var params = matrix[x][y]
      if params != null:
        map.add_child(add_cell(params, Vector2(x, y), room_size))
  map.name = "Map"
  return map
  
func add_cell(room_params, position, room_size):
  print("New cell ", position, " ", room_params)
  var cell 
  if room_params.type == "room":
    cell = GenericRoom.instance()
    cell.has_hole = room_params.has_hole
  elif room_params.type == "corridor":
    cell = GenericCorridor.instance()
  
  cell.portal_up = room_params.door_up
  cell.portal_left = room_params.door_left
  cell.portal_down = room_params.door_down
  cell.portal_right = room_params.door_right
  
  cell.translate(Vector3(position.x * room_size.x, 0, position.y * room_size.y))
  return cell
