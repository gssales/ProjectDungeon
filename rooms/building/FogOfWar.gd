extends CSGMesh

var triggered = false

func _on_Player_position_changed(new_positon, velocity):
  if not triggered and global_transform.origin.distance_to(new_positon) <= 19:
    triggered = true
    var tween = Tween.new()
    add_child(tween)
    tween.connect("tween_completed", self, "_on_Tween_tween_completed")
      
    material = SpatialMaterial.new()
    material.flags_unshaded = true
    material.flags_transparent = true  
    
    tween.interpolate_property(material, "albedo_color", Color(0,0,0,1), Color(0,0,0,0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
    tween.start()
    
func _on_Tween_tween_completed():
  queue_free()
