extends Node

var Ally = preload("res://entities/ally_1/Ally.tscn")

func generate(matrix, room_list, room_size):
  var ally_node = Spatial.new()
  for room in room_list:
    var prob = randf()
    
    var amount = 0
    if prob > 0.9:
      amount = 1
      
    for i in range(amount):
      var e = Ally.instance()
      e.translate(Vector3(room.x * room_size.x + rand_range(-10, 10), 0 ,room.y * room_size.y + rand_range(-10, 10)))
      ally_node.add_child(e)
        
  ally_node.name = "Allies"
  return ally_node


