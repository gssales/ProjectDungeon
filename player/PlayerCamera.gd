extends Spatial

var distance = 10
var veloc = Vector3.ZERO

func _ready():
  pass
  
func _process(delta):
  var update_camera = false
  if Input.is_action_just_released("zoom_in"):
    update_camera = true
    distance -= 5*distance * delta
  if Input.is_action_just_released("zoom_out"):
    update_camera = true
    distance += 5*distance * delta
    
  veloc = veloc * 23/24
  
  if update_camera:
    move_camera()
        
func move_camera():
  $Camera.look_at_from_position(
      translation + (1.5*Vector3.UP + Vector3.BACK).normalized() * distance + veloc * 1/64, 
      translation + veloc * 1/64, 
      Vector3.UP)
  
func _on_Player_position_changed(new_position, new_velocity):
  translation = new_position
  veloc += new_velocity
  move_camera()
