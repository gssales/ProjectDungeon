extends KinematicBody

export(float) var maxhealth = 35
var health = 0

func _ready():
  health = maxhealth

func _physics_process(_delta):
  if health <= 0:
    queue_free()

func take_damage(amount):
  health -= amount
  if health < 0:
    health = 0 
