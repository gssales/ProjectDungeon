class_name FindPartyLeader extends Spatial

var hear_radius = 100
var looking_for_group = "player"

var pos
func sort_by_proximity(node_a, node_b):
  return pos.distance_squared_to(node_b.transform.origin) > pos.distance_squared_to(node_a.transform.origin)

func _look_for_leader():
  pos = get_parent().transform.origin
  var heading = to_global(Vector3.FORWARD) - pos
  var wanted_list = get_tree().get_nodes_in_group(looking_for_group)
  wanted_list.sort_custom(self, "sort_by_proximity")
  
  for wanted in wanted_list:
    var dist = pos.distance_to(wanted.transform.origin)
    if dist < hear_radius:
      var intersect = get_world().direct_space_state.intersect_ray(pos, wanted.transform.origin, [self])
      if intersect.has("collider") and intersect["collider"] == wanted:
        return wanted
    else:
      break
      
  return null
