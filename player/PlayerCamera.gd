extends Spatial

signal camera_rotation(new_rotation)
export var lerp_movement = false
var distance = 10
var veloc = Vector3.ZERO

func _ready():
  move_camera()
  emit_signal("camera_rotation", $Camera.rotation.y)
  
func _process(delta):
  var update_camera = false
  if Input.is_action_just_released("zoom_in"):
    update_camera = true
    distance -= 5*distance * delta
  if Input.is_action_just_released("zoom_out"):
    update_camera = true
    distance += 5*distance * delta
  
  if lerp_movement:
    veloc = veloc * 23/24
  
  if update_camera:
    move_camera()
        
func move_camera():
  var lerp_value = Vector3.ZERO
  if lerp_movement:
    lerp_value = veloc * 1/64
  $Camera.look_at_from_position(
      translation + (1.5*Vector3.UP + Vector3.BACK + Vector3.LEFT).normalized() * distance + lerp_value, 
      translation + lerp_value, 
      Vector3.UP)
  
func _on_Player_position_changed(new_position, new_velocity):
  translation = new_position
  veloc += new_velocity
  move_camera()
