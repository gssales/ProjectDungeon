extends Spatial

export var max_depth_generation = 5
export var max_corridor_streak = 3
export var room_size := Vector2(36, 36)
export var n_rooms = 10

var Exit = preload("res://rooms/props/LevelExit.tscn")
var Player = preload("res://player/Player.tscn")
var PlayerCamera = preload("res://player/PlayerCamera.tscn")

var matrix_size
var room_list = []
var corridor_list = []

var initial_room
var found_last_room = false
var last_room

var room_amount = 0

func _ready():
  randomize()
  matrix_size = max_depth_generation*2
  initial_room = Vector2(matrix_size/2, matrix_size/2)
  last_room = Vector2(matrix_size/2, matrix_size/2)
  
  var m = generate_matrix(matrix_size)
  m = post_generation(m)
  
  if Global.current_level > 0:
    m[initial_room.x][initial_room.y].has_hole = true
  
  var map_node = $MapGenerator.generate(m, room_size)
  var lights_node = $LightingGenerator.generate(m, room_size)
  var astar = $AStarGenerator.generate(m, room_size)
  var _room_list = room_list.duplicate()
  _room_list.erase(initial_room)
  var items = $ItemSpawner.generate(m, _room_list, room_size, initial_room)
  var allies = $AllySpawner.generate(m, _room_list, room_size)
  var enemies = $EnemySpawner.generate(m, _room_list, room_size)
  
  var level_node = Spatial.new()
  level_node.name = "Generated"
  
  var camera = PlayerCamera.instance()
  
  var player
  if Global.load_player and false:
    player = Global.player
    for a in Global.allies:
      allies.add_child(a)
  else:
    player = Player.instance()
    
  player.connect("position_changed", camera, "_on_Player_position_changed")
  camera.connect("camera_rotation", player, "_on_PlayerCamera_camera_rotation")
  level_node.add_child(player)
  level_node.add_child(camera)
    
  level_node.add_child(map_node)
  level_node.add_child(lights_node)
  level_node.add_child(enemies)
  level_node.add_child(allies)
  level_node.add_child(items)
  
  var exit = Exit.instance()
  exit.translate(Vector3(last_room.x*36, 0 ,last_room.y*36))
  level_node.add_child(exit)

  player.translate(Vector3(initial_room.x*36, 0 ,initial_room.y*36))
  player.get_node("Party").astar = astar
  
  add_child(level_node)
  
  var fogs = get_tree().get_nodes_in_group("fog_of_war")
  for fog in fogs:
    player.connect("position_changed", fog, "_on_Player_position_changed")
    
  


# process para a execução do audio stream com a musica ambiente
func _process(delta):
  if $AmbientMusic.playing == false:
    $AmbientMusic.play()
  pass

func _input(event):
  if event.is_action_pressed("take_damage"):
    get_tree().reload_current_scene()

func generate_matrix(matrix_size):
  var matrix = empty_matrix(matrix_size)
  var initial_position = Vector2(matrix_size/2, matrix_size/2)
  found_last_room = false
  room_amount = 0
  room_list = []
  corridor_list = []
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
    corridor_list.push_back(position)
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
    "door_left": false,
    "has_hole": false
  }

  for neighbor in neighbors:
    if prob_array.pop_back():
      if matrix[position.x+neighbor.x][position.y+neighbor.y]:
        continue
      var next_ = neighbor.rotated(PI)
      var created = branch(matrix, position + neighbor, [next_], corridor_streak, depth + 1)
      if created:
        doors.push_back(neighbor)
        
  if not generate_corridor and not found_last_room:
    last_room = position
    found_last_room = true

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
  
