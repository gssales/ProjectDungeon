extends Node

var Ally = preload("res://entities/ally_1/Ally.tscn")

func generate(matrix, room_list, room_size, ally_count):
  var used_rooms = []
  var ally_node = Spatial.new()
    
  if ally_count < 4:
    var prob = randf()
    
    var amount = 1
    if ally_count < 3 and prob > 0.8:
      amount = 2
    
    for i in range(amount):
      var room = room_list[floor(randf() * room_list.size())]
      used_rooms.push_back(room)
      
      var e = Ally.instance()
      e.translate(Vector3(room.x * room_size.x + rand_range(-10, 10), 4 ,room.y * room_size.y + rand_range(-10, 10)))
      ally_node.add_child(e)
      
  for r in used_rooms:
    room_list.erase(r)
        
  ally_node.name = "Allies"
  return ally_node


