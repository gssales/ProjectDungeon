tool extends StaticBody
export(float, 4.0, 40, 1.0) var length = 5.0 setget set_length
export(float, 1, 8, 0.5) var height = 3.0 setget set_height
export(float, 0.6, 4, 0.2) var depth = 0.6 setget set_depth
  
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

func _process(delta):
  if Engine.editor_hint:
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
    
func set_height(new_height : float) -> void:
  height = new_height
  
func set_depth(new_depth : float) -> void:
  depth = new_depth
