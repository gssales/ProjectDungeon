extends Spatial

export var max_depth_generation = 5
export var max_corridor_streak = 3
export var room_size := Vector2(36, 36)
export var n_rooms = 10

var GenericRoom = preload("res://rooms/GenericRoom.tscn")
var GenericCorridor = preload("res://rooms/GenericCorridor.tscn")
var Enemy = preload("res://entities/enemy_1/Enemy.tscn")
var Ally = preload("res://entities/ally_1/Ally.tscn")

var should_spawn_item = true

var matrix_size
var matrix
var room_list = []

var initial_position

func _ready():
  randomize()
  matrix_size = max_depth_generation*2
  initial_position = Vector2(matrix_size/2, matrix_size/2)
  
  generate_matrix()
  post_generation()
  var map_node = add_to_map_node()
  var lights_node = $LightingGenerator.generate_lights(matrix)
  add_child(map_node)
  add_child(lights_node)
  
  var item = $ItemSpawner.spawn_random_item(initial_position*36)
  $Items.add_child(item)
  
  var enemy_inst = Enemy.instance() 
  $Enemies.add_child(enemy_inst)
  
  enemy_inst.translate(Vector3(initial_position.x*36 + 8, 0 ,initial_position.y*36 + 8))
  
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
    
func add_to_map_node() -> Spatial:
  var map = Spatial.new()
  for x in range(matrix_size):
    for y in range(matrix_size):
      var r = matrix[x][y]
      if r != null:
        map.add_child(matrix[x][y])
  return map
    
func clear_matrix():
  matrix = []
  room_list = []
  matrix.resize(matrix_size)
  for x in range(matrix_size):
    matrix[x] = []
    matrix[x].resize(matrix_size)
    for y in range(matrix_size):
      matrix[x][y] = null
  
func generate_matrix():
  clear_matrix()
  branch(initial_position)

func post_generation():
  room_list.shuffle()
  var count_rooms = room_list.size()
  for r in range(count_rooms/2):
    var position = room_list[r]
    var room = matrix[position.x][position.y]
    
    var prob = []
    if position.y-1 >= 0 and not room.portal_up and matrix[position.x][position.y-1] != null:
      prob.push_back(Vector2.UP)
    if position.x-1 >= 0 and not room.portal_left and matrix[position.x-1][position.y] != null:
      prob.push_back(Vector2.LEFT)
    if position.y+1 < matrix_size and not room.portal_down and matrix[position.x][position.y+1] != null:
      prob.push_back(Vector2.DOWN)
    if position.x+1 < matrix_size and not room.portal_right and matrix[position.x+1][position.y] != null:
      prob.push_back(Vector2.RIGHT)
      
    prob.shuffle()
    var door = prob.pop_back()
    if door == null:
      continue
    
    var neighbor_position = position + door
    var neighbor = matrix[neighbor_position.x][neighbor_position.y]
    
    if door.is_equal_approx(Vector2.UP):
      room.portal_up = true
      neighbor.portal_down = true
    if door.is_equal_approx(Vector2.LEFT):
      room.portal_left = true
      neighbor.portal_right = true
    if door.is_equal_approx(Vector2.DOWN):
      room.portal_down = true
      neighbor.portal_up = true
    if door.is_equal_approx(Vector2.RIGHT):
      room.portal_right = true
      neighbor.portal_left = true
      
    matrix[position.x][position.y] = room
    matrix[neighbor_position.x][neighbor_position.y] = neighbor
    
  
func map_neighbors(position: Vector2):
  var x = position.x
  var z = position.y
  var neighbors = []
  if x + 1 < matrix_size and matrix[x + 1][z] == null:
    neighbors.push_back(Vector2.RIGHT)
  if x - 1 >= 0 and matrix[x - 1][z] == null:
    neighbors.push_back(Vector2.LEFT)
  if z + 1 < matrix_size and matrix[x][z + 1] == null:
    neighbors.push_back(Vector2.DOWN)
  if z - 1 >= 0 and matrix[x][z - 1] == null:
    neighbors.push_back(Vector2.UP)
  return neighbors
  
func branch(position: Vector2, doors = [], corridor_streak = max_corridor_streak, depth = 0):
  if depth >= max_depth_generation or n_rooms == 0 or matrix[position.x][position.y] != null:
    return 0
  
  var map_n = map_neighbors(position)
  map_n.shuffle()
  
  var count_n = map_n.size()
  if count_n == 0:
    return 0
    
  var prob_array = []
  for i in range(1 if count_n == 1 else 4):
    prob_array.push_back(i < count_n)
  prob_array.shuffle()
  print(prob_array)
  
  var generate_corridor = false
  if corridor_streak < max_corridor_streak and randf() < 0.8:
    generate_corridor = true
    corridor_streak += 1
  else:
    n_rooms -= 1
    corridor_streak = 0
    
  matrix[position.x][position.y] = true
  var n = 0
  while n < count_n:
    if prob_array.pop_back():
      var neighbor = map_n.pop_back()
      var next_ = neighbor.rotated(PI)
      var created = branch(position + neighbor, [next_], corridor_streak, depth + 1)
      if created:
        doors.push_back(neighbor)
      else:
        if depth < max_depth_generation or n_rooms > 0:
          count_n += 1
    n += 1
  
  if generate_corridor:
    add_corridor(position, doors)
  else:
    add_room(position, doors)
  return 1
  
func add_corridor(position, doors):
  print("New Corridor ", position, " ", doors)
  var corridor = GenericCorridor.instance()
  for d in doors:
    if d.is_equal_approx(Vector2.UP):
      corridor.portal_up = true
    if d.is_equal_approx(Vector2.LEFT):
      corridor.portal_left = true
    if d.is_equal_approx(Vector2.DOWN):
      corridor.portal_down = true
    if d.is_equal_approx(Vector2.RIGHT):
      corridor.portal_right = true
  corridor.translate(Vector3(position.x * room_size.x, 0, position.y * room_size.y))
#  add_child(corridor)
  matrix[position.x][position.y] = corridor  

func add_room(position, doors):
  print("New Room ", position, " ", doors)
  var room = GenericRoom.instance()
  
  for d in doors:
    if d.is_equal_approx(Vector2.UP):
      room.portal_up = true
    if d.is_equal_approx(Vector2.LEFT):
      room.portal_left = true
    if d.is_equal_approx(Vector2.DOWN):
      room.portal_down = true
    if d.is_equal_approx(Vector2.RIGHT):
      room.portal_right = true
  room.translate(Vector3(position.x * room_size.x, 0, position.y * room_size.y))
#  add_child(room)
  matrix[position.x][position.y] = room
  room_list.push_back(position)
  
