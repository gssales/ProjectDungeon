extends Node

var ItemModel = preload("res://item/ItemModel.tscn")

var items = [
  {
    _type="espada",
    _name="Espada",
    _range=2.0,
    damageRange=[5,10],
    attack_speed = 300, #in milisecs
    modelPath="res://item/items/sword/simple_sword.tscn",
    model_transform=Transform(Vector3(0, 0.1,-1), Vector3(-1, 0, 0), Vector3(0, 1, 0.1), Vector3(0,0.05,0)),
    icon_path = "res://assets/icons/sword.png",
    weapon_model = "res://item/items/weapon1/Sword_model1.tscn",
    hitbox = "res://item/items/weapon1/Attack_Hitbox1.tscn"
  },
  {
    _type="crossbow",
    _name="Besta",
    _range=50.0,
    damageRange=[5,10],
    attack_speed = 300, #in milisecs
    modelPath="res://item/items/weapon2/crossbow_model.tscn",
    model_transform=Transform(),
    icon_path = "res://assets/icons/crossbow.png",
    weapon_model = "res://item/items/weapon2/crossbow_model.tscn",
    hitbox = ""
  },
 ]

func generate(matrix, room_list, room_size, initial_room):
  var item_node = Spatial.new()
  
  var first_item = ItemModel.instance()
  first_item.translate(Vector3(initial_room.x * room_size.x + rand_range(-10, 10), 3 ,initial_room.y * room_size.y + rand_range(-10, 10)))
  first_item.params = items[0]
  item_node.add_child(first_item)
  
  for room in room_list:
    var prob = randf()
    
    var amount = 0
    if prob > 0.8:
      amount = 1
            
    for i in range(amount):
      var item = ItemModel.instance()
      item.translate(Vector3(room.x * room_size.x + rand_range(-10, 10), 3 ,room.y * room_size.y + rand_range(-10, 10)))
      item.params = items[randi() % 2]
      item_node.add_child(item)
      
  item_node.name = "Items"
  item_node.add_to_group("item_model_container")
  return item_node


