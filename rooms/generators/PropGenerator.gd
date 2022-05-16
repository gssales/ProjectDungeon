extends Node

var Cage = preload("res://rooms/props/Cage.tscn")
var Chain0 = preload("res://rooms/props/Chain0.tscn")
var Chain1 = preload("res://rooms/props/Chain1.tscn")
var Chain2 = preload("res://rooms/props/Chain2.tscn")

var props = [
  {
#    "node": Cage,
#    "offset": Vector3(8, 1, -15.5),
#    "rotation": 0
#  },{
#    "node": Cage,
#    "offset": Vector3(6, 1, 15.5),
#    "rotation": PI
#  },{
#    "node": Cage,
#    "offset": Vector3(15.5, 1, -9),
#    "rotation": 3*PI/2
#  },{
#    "node": Cage,
#    "offset": Vector3(-15.5, 1, 8),
#    "rotation": PI/2
#  },{
    "node": Chain0,
    "offset": Vector3(13, 0, 8),
    "rotation": 1.23
  },{
    "node": Chain0,
    "offset": Vector3(-6, 0, 3),
    "rotation": 0
  },{
    "node": Chain0,
    "offset": Vector3(1, 0, -8),
    "rotation": -1.23
  },{
    "node": Chain1,
    "offset": Vector3(13, 0, 8),
    "rotation": 1.23
  },{
    "node": Chain1,
    "offset": Vector3(-6, 0, 3),
    "rotation": 0
  },{
    "node": Chain1,
    "offset": Vector3(1, 0, -8),
    "rotation": -1.23
  },{
    "node": Chain2,
    "offset": Vector3(13, 0, 8),
    "rotation": 1.23
  },{
    "node": Chain2,
    "offset": Vector3(-6, 0, 3),
    "rotation": 0
  },{
    "node": Chain2,
    "offset": Vector3(1, 0, -8),
    "rotation": -1.23
  }
 ]

func generate(matrix, room_list, room_size):
  var item_node = Spatial.new()
  
  for room in room_list:
    var prob = randf()
    
    var amount = 1
    if prob < 0.8:
      amount = 2
            
    for i in range(amount):
      var prop = props[floor(randf() * props.size())]
      var item = prop.node.instance()
      item.translate(Vector3(room.x * room_size.x, 0 ,room.y * room_size.y) + prop.offset)
      item.rotate(Vector3.UP, prop.rotation)
      item_node.add_child(item)
      
  item_node.name = "Props"
  return item_node


