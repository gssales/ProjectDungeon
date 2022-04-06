tool extends StaticBody
export(float, 4.0, 40, 1.0) var length = 36.0 setget set_length
export(float, 4.0, 40, 1.0) var depth = 36.0 setget set_depth
  
func _ready():
  $Plane.mesh = PlaneMesh.new()
  $Plane.mesh.size.x = length
  $Plane.mesh.size.y = depth
  $Plane.transform.origin = Vector3.ZERO
  
  $CollisionShape.shape = BoxShape.new()
  $CollisionShape.shape.extents = Vector3(length/2.0, 0.5, depth/2.0)
  $CollisionShape.transform.origin = Vector3.DOWN/2
  
func _process(delta):
  if Engine.editor_hint:
    $Plane.mesh = PlaneMesh.new()
    $Plane.mesh.size.x = length
    $Plane.mesh.size.y = depth
    $Plane.transform.origin = Vector3.ZERO
    
    $CollisionShape.shape = BoxShape.new()
    $CollisionShape.shape.extents = Vector3(length/2.0, 0.5, depth/2.0)
    $CollisionShape.transform.origin = Vector3.DOWN/2
    
func set_length(new_length : float) -> void:
  length = new_length
  
func set_depth(new_depth : float) -> void:
  depth = new_depth
