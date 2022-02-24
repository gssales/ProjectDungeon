extends KinematicBody

signal camera_position(pos)

export var GRAVITY = 980
export var max_speed = 15
export var acceleration = 15

var _velocity = Vector3.ZERO
var angle = 0
var speed = 0

var ref_closest_item = null

func _ready():
  $Camera.look_at(self.transform.origin, Vector3.UP)

func _input(event):
  if event is InputEventKey: 
    if event.is_action_pressed("take_damage"):
      $Health.take_damage(4)

func _physics_process(delta):
  var move_vec = Vector3()
  if Input.is_action_pressed("move_forward"):
    move_vec += Vector3.FORWARD
  if Input.is_action_pressed("move_left"):
    move_vec += Vector3.LEFT
  if Input.is_action_pressed("move_backward"):
    move_vec += Vector3.BACK
  if Input.is_action_pressed("move_right"):
    move_vec += Vector3.RIGHT

  move_vec = move_vec.normalized()

  if move_vec.length() > 0 :
    var new_yaw = atan2(move_vec.x, move_vec.z) # 0,2*PI
    var rot = Quat(Vector3(0.0, new_yaw, 0.0))
    var t = Quat($Model.transform.basis)
    var interp = t.slerp(rot, 0.2)
    $Model.transform.basis = Basis(interp)

    speed = min(speed + acceleration * delta, max_speed)
    
    #Se já passou o cooldown e não está correndo -> regen stamina
    if $Stamina/StaminaRegenTimer.is_stopped() and not Input.is_action_pressed("sprint"):
      $Stamina.regen_stamina(4*delta)
      #print("Regen stamina")
      
  else:
    speed = max(speed - acceleration * delta, 0)
    #Se já passou o cooldown e não está se movendo -> regen stamina faster
    if $Stamina/StaminaRegenTimer.is_stopped():
      $Stamina.regen_stamina(8*delta)
      #print("Regen stamina")
      
  # Se está se movendo e correndo -> aumentar velocidade e usar stamina
  if move_vec.length() > 0 and Input.is_action_pressed("sprint"): # temporario, apenas para testar interface
      move_vec *= speed*1.5
      $Stamina.use_stamina(10*delta)
      $Stamina/StaminaRegenTimer.start(1)
      #print("is sprinting")
  else: #senão velocidade normal
    move_vec *= speed

  if not $DetectGround.is_colliding():
    move_vec += Vector3.DOWN * GRAVITY * delta

  _velocity = move_vec
  _velocity = move_and_slide_with_snap(_velocity, Vector3.DOWN)
  
var cont = 0
func _process(delta):
  
  if Input.is_action_just_pressed("ui_select"):
    $Inventory.addItem({ _type= "Espada", _name= "Espada %d" % cont, _range= 1.5, damageRange= [5, 10] })
    cont += 1
    
  if Input.is_action_just_pressed("ui_accept"):
    $Inventory.toggleItem()
    
      
