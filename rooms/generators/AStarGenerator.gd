extends Node

func generate(matrix, room_size: Vector2) -> CustomAStar:
  var astar = CustomAStar.new()
  
  for x in range(matrix.size()):
    for y in range(matrix[x].size()):
      var cell = matrix[x][y]
      if not cell:
        continue
      
      var ids = {}
      if cell.type == "room":
        ids = astar.add_room(Vector3(x * room_size.x, 0, y * room_size.y))
      elif cell.type == "corridor":
        ids = astar.add_corridor(Vector3(x * room_size.x, 0, y * room_size.y))
      
      cell["astar"] = ids
      matrix[x][y] = cell
  
  for x in range(matrix.size()):
    for y in range(matrix[x].size()):
      astar = connect_cell(astar, matrix, Vector2(x, y))
  
  return astar

func connect_cell(astar, matrix, position: Vector2):
  var cell = get_cell(matrix, position)
  if cell and cell.astar:
    if cell.door_up and position.y -1 >= 0:
      var neighbor = get_cell(matrix, position + Vector2.UP)
      if neighbor and neighbor.astar:
        astar.connect_rooms(cell.astar.up_index, neighbor.astar.down_index)
      
    if cell.door_right and position.x +1 < matrix.size():
      var neighbor = get_cell(matrix, position + Vector2.RIGHT)
      if neighbor and neighbor.astar:
        astar.connect_rooms(cell.astar.right_index, neighbor.astar.left_index)
      
    if cell.door_down and position.y +1 < matrix[position.x].size():
      var neighbor = get_cell(matrix, position + Vector2.DOWN)
      if neighbor and neighbor.astar:
        astar.connect_rooms(cell.astar.down_index, neighbor.astar.up_index)
      
    if cell.door_left and position.x -1 >= 0:
      var neighbor = get_cell(matrix, position + Vector2.LEFT)
      if neighbor and neighbor.astar:
        astar.connect_rooms(cell.astar.left_index, neighbor.astar.right_index)
  
  return astar

func get_cell(matrix, position: Vector2):
  return matrix[position.x][position.y]
