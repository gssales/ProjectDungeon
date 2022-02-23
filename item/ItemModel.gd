extends KinematicBody
class_name ItemModel

var v = Vector3.ZERO
var _shader_sheen_level = -1.25
var params = {
  _type="espada",
  _name="Espada",
  _range=2.0,
  damageRange=[5,10],
  modelPath="res://item/items/models/item.obj"
}

func sheen():
  $Tween.interpolate_property(self, '_shader_sheen_level', 1.25, -1.25, 1.2, Tween.TRANS_CUBIC)
  $Tween.start()

func _ready():
  var origin = transform.origin
  transform = transform.scaled(Vector3(0.7, 0.7, 0.7))
  transform.origin = origin
  
  var mesh = load(params.modelPath) # may slow down loading when generating
  $Spatial/Sheen.mesh = mesh
  $Spatial/Model.mesh = mesh
  
  sheen()

func _process(_delta):
  if _shader_sheen_level == -1.25:
    sheen()
  $Spatial/Sheen.material.set_shader_param('sheen_level', _shader_sheen_level)
  
func _physics_process(delta):
  var velocity = v
  if not $RayCast.is_colliding():
    velocity = velocity + Vector3.DOWN * 10 * delta
  print(velocity)
  v = move_and_slide(velocity, Vector3.UP)

