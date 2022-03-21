extends Node

# options for Allies:
# 2 diferent ally nodes -> 1 as sort of an item in the world 
#   and 1 with actual AI whoose default state is FollowPlayer

# 1 ally node, activate and deactivate all scripts and sensors / or set proccess to false maybe?
#   -> initially scripts are deactivated / not loaded
#   -> when player adds ally to party -> activate / load scripts -> Ally default state: FollowPlayerState 

# 1 ally node, change it's state here from IdleState to FollowPlayerState (WanderState as a placeholder)

# Persist the ally node -> keep it in the player node? (Owner?) -> so that next level it is still there 
#   and still follows the player


signal member_added_to_party(new_member)
signal party_changed(ally_icons)

#var Party_Members = []
var ref_closest_ally = null #Ally_Idle = null

func _input(event):
  if event.is_action_released("interact") and ref_closest_ally != null:
    #add_member(ref_closest_ally.ally)
    add_member()
    var container = get_tree().get_nodes_in_group("Allies_idle_container")[0]
    if container != null:
      container.remove_child(ref_closest_ally)
    ref_closest_ally = null
      
  if event.is_action_pressed("toggle_party_member"):
    toggle_allies()


func _process(_delta):
  select_closest_ally()


func toggle_allies():
  # move aliado na segunda posicao para a primeira (aliado_0 para 1)
  move_child(get_child(1), 0)
  # move aliado na terceira posicao para a segunda (aliado_0 para 2)
  move_child(get_child(2), 1)
  emit_signal("party_changed")
  #notify_party_changed()


func add_member():
  # se a party estiver cheia -> por enquanto, remove o primeiro membro
#  if get_child_count() >= 3:
#    var ally_to_be_removed = get_child(0)
#    remove_child(ally_to_be_removed)
#    kick_from_party(ally_to_be_removed)
  
  ref_closest_ally.set_process(true)
  ref_closest_ally.set_physics_process(true)
  
  if ref_closest_ally.get_parent():
    ref_closest_ally.get_parent().remove_child(ref_closest_ally)
  add_child(ref_closest_ally)
  move_child(ref_closest_ally, 0)
  
  print("Added to party")
  
  # Signal that new member was added -> UI
  emit_signal("member_added_to_party", ref_closest_ally)
  #emit_signal("party_changed")


func add_member_2(ally_scene: PackedScene):
  # se a party estiver cheia -> por enquanto, remove o primeiro membro
  if get_child_count() >= 3:
    var ally_to_be_removed = get_child(0)
    remove_child(ally_to_be_removed)
    kick_from_party(ally_to_be_removed)
  
  #var ally_instance = ref_closest_ally.ally.instance()
  var ally_instance = ally_scene.instance()
  
  # for when / if it gets kicked out of the party
  #ally_instance.ally_idle = ref_closest_ally.ally_idle 
  ally_instance.transform.origin = ref_closest_ally.transform.origin # spawn where the idle version was
  add_child(ally_instance)
  move_child(ally_instance, 0)
  
  print("Added to party")
  
  # Signal that new member was added -> UI
  emit_signal("member_added_to_party", ref_closest_ally)
  #emit_signal("party_changed")


func select_closest_ally():
  var player_position = get_parent().transform.origin
  var closest_ally = null
  var distance = 10
  
  for ally in get_tree().get_nodes_in_group("Allies"):
    var ally_position = ally.transform.origin
    var d = ally_position.distance_to(player_position)
    if d < 5 and d < distance:
      distance = d
      closest_ally = ally
      #print(ally)
    
      
  if closest_ally != null:
    if ref_closest_ally != closest_ally:
      #if ref_closest_ally != null:
        #ref_closest_ally.show_tooltip(false)
      ref_closest_ally = closest_ally
      #ref_closest_ally.show_tooltip(true)
  else:
    if ref_closest_ally != null:
      #ref_closest_ally.show_tooltip(false)
      ref_closest_ally = null


func select_closest_ally_2():
  var player_position = get_parent().transform.origin
  var closest_ally = null
  var distance = 10
  
  for ally in get_tree().get_nodes_in_group("Allies_Idle"):
    var ally_position = ally.transform.origin
    var d = ally_position.distance_to(player_position)
    if d < 5 and d < distance:
      distance = d
      closest_ally = ally
      #print(ally)
    
      
  if closest_ally != null:
    if ref_closest_ally != closest_ally:
      #if ref_closest_ally != null:
        #ref_closest_ally.show_tooltip(false)
      ref_closest_ally = closest_ally
      #ref_closest_ally.show_tooltip(true)
  else:
    if ref_closest_ally != null:
      #ref_closest_ally.show_tooltip(false)
      ref_closest_ally = null


func kick_from_party(ally_to_be_kicked: Spatial):
  ally_to_be_kicked.set_process(false)
  ally_to_be_kicked.set_physics_process(false)
  var container = get_tree().get_nodes_in_group("Allies_idle_container")[0]
  if container != null:
    container.add_child(ally_to_be_kicked)
  
  emit_signal("party_changed")
  

func kick_from_party_2(ally_to_be_kicked: Spatial):
  #var item_model_node = preload("res://item/ItemModel.tscn").instance()
  var ally_idle = ally_to_be_kicked.ally_idle_scene.instance()
  ally_idle.transform.origin = ally_to_be_kicked.transform.origin # spawns in the ally's current position
  var container = get_tree().get_nodes_in_group("Allies_idle_container")[0]
  if container != null:
    container.add_child(ally_idle)
  
  emit_signal("party_changed")

