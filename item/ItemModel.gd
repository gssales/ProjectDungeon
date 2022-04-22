extends KinematicBody
class_name ItemModel
func get_class(): return "ItemModel"
func is_class(name): return name == "ItemModel" or .is_class(name) 

export var params = {
  _type="espada",
  _name="Espada",
  _range=2.0,
  damageRange=[5,10],
  attack_speed = 300, #in milisecs
  modelPath="res://item/items/sword/simple_sword.tscn",
  model_transform=Transform(Vector3(0, 0.1,-1), Vector3(-1, 0, 0), Vector3(0, 1, 0.1), Vector3(0,0.05,0)),
  icon_path = "res://assets/Icon1.png",
  weapon_model = "res://item/items/weapon1/Sword_model1.tscn",
  hitbox = "res://item/items/weapon1/Attack_Hitbox1.tscn"
}

var _shader_sheen_level = -1.25
var _velocity = Vector3.ZERO
var showTooltip = false

func sheen():
  $Tween.interpolate_property(self, '_shader_sheen_level', 1.25, -1.25, 1.2, Tween.TRANS_CUBIC)
  $Tween.start()
  
func show_tooltip(show):
  showTooltip = show
  $ItemTooltip.visible = show

func _ready():
  var origin = transform.origin
  transform = transform.scaled(Vector3(0.7, 0.7, 0.7))
  transform.origin = origin
  
  var mesh = load(params.modelPath) # may slow down loading when generating
#  $Spatial/Sheen.add_child(mesh.instance())
  var item_model = mesh.instance()
  item_model.name = "Model"
  $Spatial/Model.add_child(item_model)
  $Spatial/Model.transform = params.model_transform
  
  var texture = load(params.icon_path)
  $ItemTooltip.texture = texture
  
  sheen()

func _process(_delta):
  if _shader_sheen_level == -1.25:
    sheen()
  $Spatial/Sheen.material.set_shader_param('sheen_level', _shader_sheen_level)
  
func _physics_process(delta):
  if not $RayCast.is_colliding():
    _velocity = _velocity + Vector3.DOWN * 10 * delta
  _velocity = move_and_slide(_velocity, Vector3.UP)


