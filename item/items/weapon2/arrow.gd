extends RigidBody

export(float) var SPEED = 80
export(float) var DAMAGE = 7
export(float) var KILL_TIME = 2
var timer = 0 
export var shot = false
#signal enemy_hit(enemy)

# original area collision shape radius -> 0.15 -> was changed for testing

# Called when the node enters the scene tree for the first time.
func _ready():
  set_as_toplevel(true)

func _physics_process(delta):
  #var forward_direct = global_transform.basis.x.normalized()
  #global_translate(forward_direct * speed * delta)
  if shot:
    apply_impulse(transform.basis.x, transform.basis.x * SPEED)
    shot = false
  
  #print("on loop")
  
  timer += delta
  if timer >= KILL_TIME:
    queue_free()


func _on_Area_body_entered(body):
  if body.is_in_group("Enemy"):
    body.take_damage(DAMAGE)
    print("enemy shot")
    #emit_signal("enemy_hit", body)
  queue_free() # if it hit an enemy or an object/wall delete projectile
