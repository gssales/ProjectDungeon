extends Spatial

export var max_depth_generation = 5
export var max_corridor_streak = 3
export var room_size := Vector2(36, 36)
export var n_rooms = 5

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

# to save player progress we can store the player instance / obj in a global variable here
# and then when we need to create a new level, 
# we just remove the player from the level with remove_child 
# then we simply add the player as a child of the new created map
# +
# save file(s) for when a player decides to exit the game and return from where he was
# problem is to generate new levels we reload this scene so that would have to be changed 
# create a new function that removes the old map and creates a new map to put the player in

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
  var props_node = $PropGenerator.generate(m, room_list, room_size)
  var lights_node = $LightingGenerator.generate(m, room_size)
  var astar = $AStarGenerator.generate(m, room_size)
  var _room_list = room_list.duplicate()
  _room_list.erase(initial_room)
  var items = $ItemSpawner.generate(m, _room_list, room_size, initial_room)
  var allies = $AllySpawner.generate(m, _room_list, room_size, 0)
  var enemies = $EnemySpawner.generate(m, _room_list, room_size)
  
  var level_node = Spatial.new()
  level_node.name = "Generated"
  
  var camera = PlayerCamera.instance()
  
  var player = Player.instance()
    
  player.connect("position_changed", camera, "_on_Player_position_changed")
  camera.connect("camera_rotation", player, "_on_PlayerCamera_camera_rotation")
  level_node.add_child(player)
  level_node.add_child(camera)
    
  level_node.add_child(map_node)
  level_node.add_child(props_node)
  level_node.add_child(lights_node)
  level_node.add_child(enemies)
  level_node.add_child(allies)
  level_node.add_child(items)
  
  var exit = Exit.instance()
  exit.translate(Vector3(last_room.x*36, 0 ,last_room.y*36))
  level_node.add_child(exit)

  # ver se n??o d?? problema caso player (x,y,z) != origin (0,0,0)
  # talvez player.translation(Vector3(initial_room.x*36, 0 ,initial_room.y*36))
  player.translate(Vector3(initial_room.x*36, 0 ,initial_room.y*36))
  player.get_node("Party").astar = astar
  
  add_child(level_node)
  
  exit.connect("go_to_next_level", player.get_node("GameUILayer/GameUI"), "on_LevelExit_go_to_next_level")
  player.get_node("DetectDarkness").connect("darkness_changed", $WorldEnvironment, "_on_DetectDarkness_darkness_changed")
  
  var fogs = get_tree().get_nodes_in_group("fog_of_war")
  for fog in fogs:
    player.connect("position_changed", fog, "_on_Player_position_changed")    



# process para a execu????o do audio stream com a musica ambiente
func _process(delta):
  if $AmbientMusic.playing == false:
    $AmbientMusic.play()
  pass

func _input(event):
  if event.is_action_pressed("take_damage"):
    #get_tree().reload_current_scene()
    Global.current_level = 0
    get_tree().change_scene("res://Generation.tscn")

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
  
func on_LevelExit_go_to_next_level(player):
  #save_player_progress()
  generate_level(Global.current_level)


# to do:
#   get player camera and disconnect its signals before connecting the new camera signals
#   change LevelExit to send a signal to this node (LevelGeneration)
#     to inform it that it needs to go to the next level
#   connect the LevelExit signal to this node so that it can receive it and process 

# call this to generate a level 
func generate_level(level_number:int):
  randomize()
  matrix_size = max_depth_generation*2
  initial_room = Vector2(matrix_size/2, matrix_size/2)
  last_room = Vector2(matrix_size/2, matrix_size/2)
  
  # number of rooms increases in 5 every 5 levels: 5, 10, 15...
  n_rooms = ((level_number / 5) + 1) * 5
  
  var m = generate_matrix(matrix_size)
  m = post_generation(m)
  
  if Global.current_level > 0:
    m[initial_room.x][initial_room.y].has_hole = true
    
  # generate structures, items and characters/entities
  var map_node = $MapGenerator.generate(m, room_size)
  var props_node = $PropGenerator.generate(m, room_list, room_size)
  var lights_node = $LightingGenerator.generate(m, room_size)
  var astar = $AStarGenerator.generate(m, room_size)
  var _room_list = room_list.duplicate()
  _room_list.erase(initial_room)
  var items = $ItemSpawner.generate(m, _room_list, room_size, initial_room)
  var allies = $AllySpawner.generate(m, _room_list, room_size, get_tree().get_nodes_in_group("ally").size())
  var enemies = $EnemySpawner.generate(m, _room_list, room_size)
  
  var current_level
  var player
  var camera
  
  # salva o player e aliados da equipe para serem inseridos no novo mapa
  if level_number > 0:
    # Encontra o nodo Generated que cont??m o mapa atual
    current_level = get_children().pop_back()
    
    camera = current_level.get_node("PlayerCamera")
    if camera != null:
      current_level.remove_child(camera)
    
    var player_group = get_tree().get_nodes_in_group("player")
    if not player_group.empty():
      player = player_group[0]
      var party_members = get_tree().get_nodes_in_group("ally")
      var allies_in_level = current_level.get_node("Allies")
      for ally in party_members:
        allies_in_level.remove_child(ally)
        add_child(ally)
      current_level.remove_child(player)
    
    # deconectar fogs do mapa antigo antes de conectar novamente
    var fogs = get_tree().get_nodes_in_group("fog_of_war")
    for fog in fogs:
      #if player.is_connected("position_changed", fog, "_on_Player_position_changed"):
      player.disconnect("position_changed", fog, "_on_Player_position_changed") 
    
    # deleta o mapa antigo 
    current_level.queue_free()
    
  
  # Gera o novo mapa
  var level_node
  level_node = Spatial.new()
  level_node.name = "Generated"
  
  #var camera = PlayerCamera.instance()
  if level_number == 0:
    player = Player.instance()
    camera = PlayerCamera.instance()
    player.connect("position_changed", camera, "_on_Player_position_changed")
    camera.connect("camera_rotation", player, "_on_PlayerCamera_camera_rotation")
    
#  player.connect("position_changed", camera, "_on_Player_position_changed")
#  camera.connect("camera_rotation", player, "_on_PlayerCamera_camera_rotation")
  level_node.add_child(player)
  level_node.add_child(camera)
    
  level_node.add_child(map_node)
  level_node.add_child(props_node)
  level_node.add_child(lights_node)
  level_node.add_child(enemies)
  level_node.add_child(allies)
  level_node.add_child(items)
  
  var exit = Exit.instance()
  exit.translate(Vector3(last_room.x*36, 0 ,last_room.y*36))
  level_node.add_child(exit)

  # translation ao inv??s de translate() pq player (x,y,z) != origin (0,0,0)
  player.translation = Vector3(initial_room.x*36, 0 ,initial_room.y*36)
  player.get_node("Party").astar = astar
  
  var party_members = get_tree().get_nodes_in_group("ally")
  for ally in party_members:
    remove_child(ally)
    ally.astar = astar
    allies.add_child(ally)
    ally.translation = Vector3(initial_room.x*36 + rand_range(-6, 6), 0 ,initial_room.y*36 + + rand_range(-6, 6))
    
  add_child(level_node)
  
  exit.connect("go_to_next_level", player.get_node("GameUILayer/GameUI"), "on_LevelExit_go_to_next_level")
  var detect_dark = player.get_node("DetectDarkness")
  if not detect_dark.is_connected("darkness_changed", $WorldEnvironment, "_on_DetectDarkness_darkness_changed"):
    detect_dark.connect("darkness_changed", $WorldEnvironment, "_on_DetectDarkness_darkness_changed")
  
  # deconectar fogs do mapa antigo antes de conectar novamente
  var fogs = get_tree().get_nodes_in_group("fog_of_war")
  for fog in fogs:
    player.connect("position_changed", fog, "_on_Player_position_changed")    
