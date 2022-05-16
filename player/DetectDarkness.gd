extends Spatial

signal darkness_changed(is_dark)

var TICK = 1
var elapsed = 0

func _physics_process(delta):
  elapsed += delta
  if elapsed >= TICK:
    elapsed = 0
      
    for light in get_tree().get_nodes_in_group("torch"):
      if light.global_transform.origin.distance_to(global_transform.origin) < 18:
        var intersect = get_world().direct_space_state.intersect_ray(global_transform.origin, light.global_transform.origin)
        if intersect.has("collider") and intersect["collider"] == light:
          emit_signal("darkness_changed", false)
          return
        
    emit_signal("darkness_changed", true)
  
