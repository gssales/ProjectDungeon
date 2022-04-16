class_name CustomAStar extends AStar


func add_room(position: Vector3) -> Dictionary:
  var result = {}
  
  result["up_index"] = get_available_point_id()
  add_point(result["up_index"], position + Vector3.FORWARD * 15)
  result["right_index"] = get_available_point_id()
  add_point(result["right_index"], position + Vector3.RIGHT * 15)
  result["down_index"] = get_available_point_id()
  add_point(result["down_index"], position + Vector3.BACK * 15)
  result["left_index"] = get_available_point_id()
  add_point(result["left_index"], position + Vector3.LEFT * 15)
  
  connect_points(result["up_index"], result["right_index"])
  connect_points(result["right_index"], result["down_index"])
  connect_points(result["down_index"], result["left_index"])
  connect_points(result["left_index"], result["up_index"])
  connect_points(result["up_index"], result["down_index"])
  connect_points(result["right_index"], result["left_index"])
  
  return result

func add_corridor(position: Vector3) -> Dictionary:
  var result = {}
  
  var corridor_index = get_available_point_id()
  result["up_index"] = corridor_index
  result["right_index"] = corridor_index
  result["down_index"] = corridor_index
  result["left_index"] = corridor_index
  
  add_point(corridor_index, position)
  
  return result

func connect_rooms(origin_id: int, target_id: int) -> void:
  if not are_points_connected(origin_id, target_id):
    connect_points(origin_id, target_id, true)

func next_in_path_toward(origin: Vector3, target: Vector3) -> Vector3:
  var result = origin
  
  var origin_id = get_closest_point(origin)
  var target_id = get_closest_point(target)
  var path_sequence = get_point_path(origin_id, target_id)
  
  if path_sequence[0]:
    result = path_sequence[0]
  
  if path_sequence[1] and origin.distance_to(result) <= 1:
    result = path_sequence[1]
  
  return result
