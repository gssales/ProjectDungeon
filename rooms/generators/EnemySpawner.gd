extends Node

var Enemy = preload("res://entities/enemy_1/Enemy.tscn")

func generate(matrix, room_list, room_size):
  var enemy_node = Spatial.new()
  
  var n_enemies = (Global.current_level / 5 + 1) * 5 + (Global.current_level % 5) * (Global.current_level / 5 + 1)
  
  for i in range(n_enemies):
    var room = room_list[floor(randf() * room_list.size())]
    
    var e = Enemy.instance()
    e.damage = [min(Global.current_level/2, 15), min(Global.current_level +10, 40)]
    e.max_force = 50 + Global.current_level / 2
    e.translate(Vector3(room.x * room_size.x + rand_range(-10, 10), 4 ,room.y * room_size.y + rand_range(-10, 10)))
    enemy_node.add_child(e)
        
  enemy_node.name = "Enemies"
  return enemy_node


