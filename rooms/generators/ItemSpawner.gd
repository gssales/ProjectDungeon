extends Node

var ItemModel = preload("res://item/ItemModel.tscn")

var items = [
  {
    rarity=10,
    _type="espada",
    _name="Espada",
    _range=2.0,
    damageRange=[5,10],
    attack_speed = 300, #in milisecs
    modelPath="res://item/items/sword/simple_sword.tscn",
    model_transform=Transform(Vector3(0, 0, 2), Vector3(-2, 0, 0), Vector3(0, -2, 0), Vector3(0,0.05,0)),
    icon_path = "res://assets/icons/sword.png",
    weapon_model = "res://item/items/weapons/item_1.tscn",
    hitbox = "res://item/items/weapons/item_1_hitbox.tscn"
  },
  {
    rarity=2,
    _type="crossbow",
    _name="Besta",
    _range=50.0,
    damageRange=[20,30],
    attack_speed = 3000, #in milisecs
    modelPath="res://item/items/weapon2/crossbow_model.tscn",
    model_transform=Transform(),
    icon_path = "res://assets/icons/crossbow.png",
    weapon_model = "res://item/items/weapon2/crossbow_model.tscn",
    hitbox = null
  },
 ]

func generate(matrix, room_list, room_size, initial_room):
  var item_node = Spatial.new()
  
  var prob_array = []
  for i in range(items.size()):
    var item = items[i]
    for x in range(item.rarity):
      prob_array.push_back(i)
  prob_array.shuffle()
  
  var first_item = ItemModel.instance()
  first_item.translate(Vector3(initial_room.x * room_size.x + rand_range(-10, 10), 3 ,initial_room.y * room_size.y + rand_range(-10, 10)))
  first_item.params = items[0]
  item_node.add_child(first_item)
  
  for room in room_list:
    var prob = randf()
    
    var amount = 0
    if prob > 0.9:
      amount = 1
            
    for i in range(amount):
      var item = ItemModel.instance()
      item.translate(Vector3(room.x * room_size.x + rand_range(-10, 10), 3 ,room.y * room_size.y + rand_range(-10, 10)))
      item.params = items[randi() % 2]
      item_node.add_child(item)
      
  item_node.name = "Items"
  item_node.add_to_group("item_model_container")
  return item_node


