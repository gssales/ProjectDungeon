tool extends CSGBox

func _ready():
  pass
  
func _process(_delta):
  if Engine.editor_hint:
    width = get_parent().length
    depth = get_parent().depth
    height = get_parent().height
    transform.origin = Vector3.ZERO
    translate(Vector3(width/2.0, height/2.0, 0))
