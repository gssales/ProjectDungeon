extends Spatial
class_name ItemSpawner

var should_spawn = false 
var base_item_name = "item_"
var world_item = preload("res://item/ItemModel.tscn")
var base_item_path = "res://item/items/weapons/"
var n_items = 2

func _ready():
  pass

func spawn_random_item(room_position):
  # idea: 
  #   get a random number from 1 to n (max num of items for now n = 2)
  #   instance the item whoose name is item_<random_num_here>
  #   put it's model and hitbox in the ItemModel
  #   set it's stats somehow 
  #   put the ItemModel in the room 
  
  var item_name = ""
  var item_path = ""
  
  var item_num = randi() % n_items + 1
  
  item_name = base_item_name.insert(base_item_name.length(), String(item_num))
  item_path = base_item_path.insert(base_item_path.length(), item_name + ".tscn")
  
  var item_model = load(item_path)
  var item_inst = item_model.instance()
  
  var witem_inst : ItemModel = world_item.instance()
  if item_inst.type == "espada":
    witem_inst.params._type = item_inst.type
    witem_inst.params._name = item_inst.type
    witem_inst.params.damageRange = [5,10]
    witem_inst.params.attack_speed = 300
    #witem_inst.params.modelPath= "res://item/items/models/item.obj"
    witem_inst.params.icon_path = "res://assets/Item1.png"
    witem_inst.params.weapon_model = item_path
    witem_inst.params.hitbox = base_item_path.insert(base_item_path.length(), item_name + "_hitbox.tscn")
    item_inst.queue_free()
    
  elif item_inst.type == "crossbow":
    #var witem_inst : ItemModel = world_item.instance()
    witem_inst.params._type = item_inst.type
    witem_inst.params._name = item_inst.type
    witem_inst.params.damageRange = [5,10]
    witem_inst.params.attack_speed = 300
    #witem_inst.params.modelPath= "res://item/items/models/item.obj"
    witem_inst.params.icon_path = "res://assets/Item1.png"
    witem_inst.params.weapon_model = item_path
    witem_inst.params.hitbox = null
    #witem_inst.params["name"] = item_inst.type
    item_inst.queue_free()
  
  print(witem_inst)
  #print(get_parent())
  witem_inst.translate(Vector3(room_position.x, 0, room_position.y))
  
  return witem_inst
  
