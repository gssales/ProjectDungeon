extends Spatial

export var max_depth_generation = 5
export var max_corridor_streak = 3
export var room_size := Vector2(36, 36)
export var n_rooms = 10

var GenericRoom = preload("res://rooms/GenericRoom.tscn")
var GenericCorridor = preload("res://rooms/GenericCorridor.tscn")
var Enemy = preload("res://entities/enemy_1/Enemy.tscn")
var Ally = preload("res://entities/ally_1/Ally.tscn")

var matrix_size
var room_list = []

var initial_position

var room_amount = 0

func _ready():
  randomize()
  matrix_size = max_depth_generation*2
  initial_position = Vector2(matrix_size/2, matrix_size/2)
  
  var m = generate_matrix(matrix_size)
  m = post_generation(m)
  
  var map_node = add_to_map_node(m)
  add_child(map_node)
  $Player.translate(Vector3(initial_position.x*36, 0 ,initial_position.y*36))
  return
  
  var lights_node = $LightingGenerator.generate_lights(matrix)
  add_child(lights_node)
  
  var item = $ItemSpawner.spawn_random_item(initial_position*36)
  $Items.add_child(item)
  
  for r in room_list:
    var enemy_inst = Enemy.instance() 
    $Enemies.add_child(enemy_inst)
    enemy_inst.translate(Vector3(r.x*36 + 8, 0 ,r.y*36 + 8))
  
  var ally_inst = Ally.instance()
  $Allies.add_child(ally_inst)
  
  ally_inst.translate(Vector3(initial_position.x*36 - 8, 0 ,initial_position.y*36 - 8))
  
  print(n_rooms)
  $Player.translate(Vector3(initial_position.x*36, 0 ,initial_position.y*36))
  
  var fogs = get_tree().get_nodes_in_group("fog_of_war")
  for fog in fogs:
    $Player.connect("position_changed", fog, "_on_Player_position_changed")
    
func _input(event):
  if event.is_action_pressed("take_damage"):
    get_tree().reload_current_scene()

func generate_matrix(matrix_size):
  var matrix = empty_matrix(matrix_size)
  var initial_position = Vector2(matrix_size/2, matrix_size/2)
  room_amount = 0
  room_list = []
  branch(matrix, initial_position)
  return matrix
  
func empty_matrix(size: int):
  var m = []
  m.resize(size)
  for x in range(size):
    m[x] = []
    m[x].resize(size)
  return m
  
func branch(matrix, position: Vector2, doors = [], corridor_streak = max_corridor_streak, depth = 0):
  var neighbors = list_free_neighbors(matrix, position)
  var count_neighbors = neighbors.size()
  
  if depth >= max_depth_generation or room_amount == n_rooms or count_neighbors == 0:
    return 0
    
  neighbors.shuffle()
  
  var prob_array = []
  for i in range(1 if count_neighbors == 1 else 4):
    prob_array.push_back(i < count_neighbors)
  prob_array.shuffle()

  var generate_corridor = false
  if corridor_streak < max_corridor_streak and randf() < 0.8:
    generate_corridor = true
    corridor_streak += 1
  else:
    room_amount += 1
    room_list.push_back(position)
    corridor_streak = 0
    
  matrix[position.x][position.y] = {
    "type": "corridor" if generate_corridor else "room",
    "door_up": false,
    "door_right": false,
    "door_down": false,
    "door_left": false
  }

  for neighbor in neighbors:
    if prob_array.pop_back():
      if matrix[position.x+neighbor.x][position.y+neighbor.y]:
        continue
      var next_ = neighbor.rotated(PI)
      var created = branch(matrix, position + neighbor, [next_], corridor_streak, depth + 1)
      if created:
        doors.push_back(neighbor)

  for door in doors:
    set_door(matrix, position, door)
  
  return 1

func list_free_neighbors(matrix, position: Vector2):
  var x = position.x
  var z = position.y
  var size = matrix.size()
  var neighbors = []
  if x+1 < size and matrix[x+1][z] == null:
    neighbors.push_back(Vector2.RIGHT)
  if x-1 >= 0 and matrix[x-1][z] == null:
    neighbors.push_back(Vector2.LEFT)
  if z+1 < size and matrix[x][z+1] == null:
    neighbors.push_back(Vector2.DOWN)
  if z-1 >= 0 and matrix[x][z-1] == null:
    neighbors.push_back(Vector2.UP)
  return neighbors
  
func list_full_neighbors(matrix, position: Vector2):
  var x = position.x
  var z = position.y
  var size = matrix.size()
  var neighbors = []
  if x+1 < size and matrix[x+1][z] != null and not matrix[x+1][z].door_right:
    neighbors.push_back(Vector2.RIGHT)
  if x-1 >= 0 and matrix[x-1][z] != null and not matrix[x-1][z].door_left:
    neighbors.push_back(Vector2.LEFT)
  if z+1 < size and matrix[x][z+1] != null and not matrix[x][z+1].door_down:
    neighbors.push_back(Vector2.DOWN)
  if z-1 >= 0 and matrix[x][z-1] != null and not matrix[x][z-1].door_up:
    neighbors.push_back(Vector2.UP)
  return neighbors
  
func set_door(matrix, position: Vector2, door: Vector2):
  if door.is_equal_approx(Vector2.UP):
    matrix[position.x][position.y]["door_up"] = true
  if door.is_equal_approx(Vector2.RIGHT):
    matrix[position.x][position.y]["door_right"] = true
  if door.is_equal_approx(Vector2.DOWN):
    matrix[position.x][position.y]["door_down"] = true
  if door.is_equal_approx(Vector2.LEFT):
    matrix[position.x][position.y]["door_left"] = true
 
func post_generation(matrix):
  room_list.shuffle()
  for r in range(room_amount/2):
    var position = room_list[r]
    
    var neighbors = list_full_neighbors(matrix, position)
    neighbors.shuffle()
    
    var door = neighbors.pop_back()
    if door == null:
      continue
  
    var neighbor_position = position + door
    
    set_door(matrix, position, door)
    set_door(matrix, neighbor_position, door.rotated(PI))
    
  return matrix
  
func add_to_map_node(matrix) -> Spatial:
  var size = matrix.size()
  var map = Spatial.new()
  for x in range(size):
    for y in range(size):
      var params = matrix[x][y]
      if params != null:
        map.add_child(add_cell(params, Vector2(x, y)))
  return map

func add_cell(room_params, position):
  print("New cell ", position, " ", room_params)
  var cell 
  if room_params.type == "room":
    cell = GenericRoom.instance()
  elif room_params.type == "corridor":
    cell = GenericCorridor.instance()
  
  cell.portal_up = room_params.door_up
  cell.portal_left = room_params.door_left
  cell.portal_down = room_params.door_down
  cell.portal_right = room_params.door_right
  
  cell.translate(Vector3(position.x * room_size.x, 0, position.y * room_size.y))
  return cell
