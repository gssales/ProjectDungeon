extends Node

<<<<<<< HEAD
var inventory

func _ready():
  pass

func picup_item():
  pass

func switch_item():
  pass

func drop_item():
  pass
=======
func toggleItem():
  move_child(get_child(1), 0)
  
func addItem(params):
  var item_node = preload("res://item/Item.tscn").instance()
  item_node.init(params)
  item_node.name = params._name
  print ("item added")
  
  if get_child_count() >= 2:
    remove_child(get_child(0))
  add_child(item_node)
  move_child(item_node, 0)
  
  for child in get_children():
    print(child.get_name())
>>>>>>> 23f2856 (inventory node)
