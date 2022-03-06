extends Area

export(float) var range_z = 3 

# Called when the node enters the scene tree for the first time.
func _ready():
  $CollisionShape.shape.set("z", range_z)
  #pass
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func set_attack_range(value):
  $CollisionShape.shape.set("z", value)

func set_attack_width(_value):
  pass
