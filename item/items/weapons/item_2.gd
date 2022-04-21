extends Spatial

export var type = "crossbow"
export(PackedScene) var bolt
export(float) var bolt_spedd = 120
export(float) var bolt_damage = 7
#var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#  timer += delta
#  if timer >= 0.5:
#    shoot()
#    timer = 0
  
  
func shoot():
  var bolt_inst = bolt.instance()
  bolt_inst.global_transform = $FirePoint.global_transform
  bolt_inst.SPEED = bolt_spedd
  bolt_inst.DAMAGE = bolt_damage
  bolt_inst.shot = true
  var scene_root = get_tree().get_root().get_children()[0] #root node
  scene_root.add_child(bolt_inst)
  #$FirePoint.add_child(bolt_inst)
