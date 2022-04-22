tool extends StaticBody
export(float, 4.0, 40, 1.0) var length = 36.0 setget set_length
export(float, 4.0, 40, 1.0) var depth = 36.0 setget set_depth

func _ready():
  $Plane.mesh = CubeMesh.new()
  $Plane.mesh.size.x = length
  $Plane.mesh.size.y = 1
  $Plane.mesh.size.z = depth
  $Plane.transform.origin = Vector3(0,-0.5,0)
  
  $CollisionShape.shape = BoxShape.new()
  $CollisionShape.shape.extents = Vector3(length/2.0, 0.5, depth/2.0)
  $CollisionShape.transform.origin = Vector3.DOWN/2
  
func _process(delta):
  if Engine.editor_hint:
    $Plane.mesh = CubeMesh.new()
    $Plane.mesh.size.x = length
    $Plane.mesh.size.y = 1
    $Plane.mesh.size.z = depth
    $Plane.transform.origin = Vector3(0,-0.5,0)
    
    $CollisionShape.shape = BoxShape.new()
    $CollisionShape.shape.extents = Vector3(length/2.0, 0.5, depth/2.0)
    $CollisionShape.transform.origin = Vector3.DOWN/2
    
func show_hole(show):
  $Plane/Hole.visible = show
    
func set_length(new_length : float) -> void:
  length = new_length
  
func set_depth(new_depth : float) -> void:
  depth = new_depth
