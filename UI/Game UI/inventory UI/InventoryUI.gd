extends HBoxContainer

func _ready():
  pass

func _on_Inventory_inventory_changed(item_icons):
  if item_icons.size() >= 1 and item_icons[0] != null:
    var icon1 = load(item_icons[0])
    $Item1.texture = icon1
    
  if item_icons.size() >= 2 and item_icons[1] != null:
    var icon2 = load(item_icons[1])
    $Item2.texture = icon2
