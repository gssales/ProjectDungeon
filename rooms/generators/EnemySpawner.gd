extends Node

var Enemy = preload("res://entities/enemy_1/Enemy.tscn")

func generate(matrix, room_list, room_size):
  var enemy_node = Spatial.new()
  for room in room_list:
    var prob = randf()
    
    var amount = 2
    if prob < 0.5:
      amount = 4
    elif prob > 0.95:
      amount = 8
      
    for i in range(amount):
      var e = Enemy.instance()
      e.translate(Vector3(room.x * room_size.x + rand_range(-10, 10), 0 ,room.y * room_size.y + rand_range(-10, 10)))
      enemy_node.add_child(e)
        
  enemy_node.name = "Enemies"
  return enemy_node


