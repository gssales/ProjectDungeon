tool extends StaticBody
export(float, 5.0, 20, 1.0) var length = 5.0 setget set_length
export(float, 1, 5, 0.5) var height = 3.0 setget set_height
export(float, 0.6, 3, 0.6) var depth = 0.6 setget set_depth
  
func _ready():
  $CSGBox.width = length
  $CSGBox.height = height
  $CSGBox.depth = depth
  $CSGBox.transform.origin = Vector3.ZERO
  $CSGBox.translate(Vector3(length/2.0, height/2.0, 0))
  
  $CollisionShape.shape = BoxShape.new()
  $CollisionShape.shape.extents = Vector3(length/2.0, height/2.0, depth/2.0)
  $CollisionShape.transform.origin = Vector3.ZERO
  $CollisionShape.translate(Vector3(length/2.0, height/2.0, 0))
  
func set_length(new_length : float) -> void:
  length = new_length
  if Engine.editor_hint:
    $CSGBox.width = length
    $CSGBox.transform.origin = Vector3.ZERO
    $CSGBox.translate(Vector3(length/2.0, height/2.0, 0))
    
func set_height(new_height : float) -> void:
  height = new_height
  if Engine.editor_hint:
    $CSGBox.height = height
    $CSGBox.transform.origin = Vector3.ZERO
    $CSGBox.translate(Vector3(length/2.0, height/2.0, 0))
  
func set_depth(new_depth : float) -> void:
  depth = new_depth
  if Engine.editor_hint:
    $CSGBox.depth = depth
