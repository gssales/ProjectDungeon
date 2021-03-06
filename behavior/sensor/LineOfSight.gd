class_name LineOfSight extends Sensor

signal entity_entered(entity)
signal entity_exited(entity)
signal update_closest_entity(entity)

var seen_entities := []

var hear_radius = 15
var view_radius = 30
var field_of_view = PI/3
var looking_for_groups = []
  
func sort_by_proximity(node_a, node_b): # cuidado ao usar: problema quando um dos nodos é deletado
  return get_position().distance_squared_to(node_b.transform.origin) \
    > get_position().distance_squared_to(node_a.transform.origin)

func is_on_field_of_view(heading: Vector3, vector: Vector3):
  var angle = heading.angle_to(vector)
  return angle < field_of_view

func update(_delta: float) -> void:
  var heading = to_global(Vector3.FORWARD) - get_position()
  
  var wanted_list = []
  for group in looking_for_groups: # problema quando nodo é deletado 
    var nodes = get_tree().get_nodes_in_group(group)
    #wanted_list.append_array(get_tree().get_nodes_in_group(group))
    
    #remove non valid instances if any
    for node in nodes:
      if not is_instance_valid(node):
        nodes.erase(node)
    
    wanted_list.append_array(nodes)
  wanted_list.sort_custom(self, "sort_by_proximity")
  
  var seen_list = []
  for wanted in wanted_list:
    var dist = get_position().distance_to(wanted.transform.origin)
    if dist < hear_radius:
      var intersect = intersect_ray(wanted.transform.origin)
      if intersect.has("collider") and intersect["collider"] == wanted:
        seen_list.append(wanted)
    elif dist < view_radius:
      if is_on_field_of_view(heading, wanted.transform.origin - get_position()):
        var intersect = intersect_ray(wanted.transform.origin)
        if intersect.has("collider") and intersect["collider"] == wanted:
          seen_list.append(wanted)
    else:
      break
      
  for entity in seen_entities:
    if not seen_list.has(entity):
      emit_signal("entity_exited", entity)
      seen_entities.erase(entity)
      
  for seen in seen_list:
    if not seen_entities.has(seen):
      emit_signal("entity_entered", seen)
      seen_entities.push_front(seen)
      
  if seen_entities.size() > 0: # problema quando nodo é deletado 
    seen_entities.sort_custom(self, "sort_by_proximity")
    var entity = seen_entities[0]
    emit_signal("update_closest_entity", entity)
  else:
    emit_signal("update_closest_entity", null)
