extends Node

signal inventory_changed(item_icons)
#added
signal new_weapon_equipped(new_weapon, new_hitbox)

var ref_closest_item = null
var equipped_weapon : Node #added

func _input(event):
  if event is InputEventKey: 
    if event.is_action_pressed("interact") and ref_closest_item != null:
      add_item(ref_closest_item.params)
      var container = get_tree().get_nodes_in_group("item_model_container")[0]
      if container != null:
        container.remove_child(ref_closest_item)
      ref_closest_item = null
      
    if event.is_action_pressed("toggle_item"):
      toggle_item()


func _process(_delta):
  select_closest_item()


func toggle_item():
  move_child(get_child(1), 0)
  notify_inventory_changed()
  
  #added
  equipped_weapon = get_child(0)
  if equipped_weapon:
    var weapon_model = equipped_weapon.get_weapon_model()
    var hitbox = equipped_weapon.get_hitbox()
    emit_signal("new_weapon_equipped", load(weapon_model), load(hitbox)) #ver se tem como fazer isso sem o load
    #equipped_weapon = get_child(0).get_weapon_model()
    #emit_signal("new_weapon_equipped", load(equipped_weapon))
 
func add_item(params):
  var item_node = preload("res://item/Item.tscn").instance()
  item_node.init(params)
  item_node.name = params._name
  
  if get_child_count() >= 2:
    var item_to_be_dropped = get_child(0)
    remove_child(item_to_be_dropped)
    drop_item(item_to_be_dropped.params)
    
  add_child(item_node)
  move_child(item_node, 0)
  
  # Send item model to be equipped
#  equipped_weapon = item_node.get_weapon_model()
#  emit_signal("new_weapon_equipped", load(equipped_weapon)) #ver se tem como fazer isso sem o load
  equipped_weapon = item_node
  var weapon_model = equipped_weapon.get_weapon_model()
  var hitbox = equipped_weapon.get_hitbox()
  emit_signal("new_weapon_equipped", load(weapon_model), load(hitbox)) #ver se tem como fazer isso sem o load
  
  notify_inventory_changed()


func drop_item(params):
  var item_model_node = preload("res://item/ItemModel.tscn").instance()
  item_model_node.params = params
  item_model_node.transform.origin = get_parent().transform.origin
  var container = get_tree().get_nodes_in_group("item_model_container")[0]
  if container != null:
    container.add_child(item_model_node)


func select_closest_item():
  var player_position = get_parent().transform.origin
  var closest_item = null
  var distance = 10
  
  for item in get_tree().get_nodes_in_group("items"):
    var item_position = item.transform.origin
    var d = item_position.distance_to(player_position)
    if d < 5 and d < distance:
      distance = d
      closest_item = item
      
  if closest_item != null:
    if ref_closest_item != closest_item:
      if ref_closest_item != null:
        ref_closest_item.show_tooltip(false)
      ref_closest_item = closest_item
      ref_closest_item.show_tooltip(true)
  else:
    if ref_closest_item != null:
      ref_closest_item.show_tooltip(false)
      ref_closest_item = null


func notify_inventory_changed():
  var item_icons = []
  for item in get_children():
    item_icons.append(item.params.icon_path)
  emit_signal("inventory_changed", item_icons)
