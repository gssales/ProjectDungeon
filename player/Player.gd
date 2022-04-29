extends KinematicBody

signal position_changed(new_position, new_velocity)

export var GRAVITY = 980
export var max_speed = 15
export var acceleration = 15

var _velocity = Vector3.ZERO
var _position = Vector3.ZERO
var angle = 0
var speed = 0

var ref_closest_item = null

var cursor_pos = Vector3()
var camera_rotation = 0

onready var inventory = get_node("Inventory")
onready var attack_hitbox : Area
onready var attack_cooldown = get_node("Attack_timer")
var weapon_damage = 7
var weapon_model : Spatial
var equipped_weapon : Node
var attack_speed = 0.3
var has_weapon = false

onready var anim_tree = $Model/lw_polly_char_4_Dir_Mov/AnimationTree

func _ready():
  $Camera.look_at(self.transform.origin, Vector3.UP)

#func _input(event):
#  if event is InputEventKey: 
#    if event.is_action_pressed("take_damage"):
#      $Health.take_damage(4)

func _physics_process(delta):
  var move_vec = Vector3()
  var direction = Vector3()
  var n_cursor = cursor_pos.normalized()
  
  if Input.is_action_pressed("move_forward"):
    move_vec += Vector3.FORWARD
    #irection += Vector3.FORWARD.rotated(Vector3.UP, n_cursor)
  if Input.is_action_pressed("move_left"):
    move_vec += Vector3.LEFT
  if Input.is_action_pressed("move_backward"):
    move_vec += Vector3.BACK
  if Input.is_action_pressed("move_right"):
    move_vec += Vector3.RIGHT

  # direcao deve ser a direcao de movimento, porem em relacao a onde o jogador esta olhando
  direction = -move_vec.rotated(Vector3.UP, camera_rotation).rotated(Vector3.UP, -$Model.rotation.y)
  
  move_vec = move_vec.normalized().rotated(Vector3.UP, camera_rotation)
  
  #look_at_cursor() 
  
  # Seleciona a animacao baseado no vetor direction
  anim_tree.set("parameters/idle_walk/blend_position", Vector2(-direction.x, direction.z))
  
  # Combat controls: 
  if Input.is_action_pressed("attack") and attack_cooldown.is_stopped():
    
    if inventory.get_child_count() != 0:
      equipped_weapon = inventory.get_child(0)
    # If its a sword / melee type weapon -> use hitbox
    if equipped_weapon != null:
      weapon_damage = equipped_weapon.damage() # get weapon damage
      attack_speed = equipped_weapon.get_attack_speed() / 1000.0 # get attack speed (milisecs)
      if equipped_weapon.get_type() == "espada":
        if attack_hitbox != null: # depois fazer a hitbox ficar ativa somente por um periodo de tempo
          for body in attack_hitbox.get_overlapping_bodies(): # search for entities in attack hittbox
            if body.is_in_group("Enemy"): #if it is an enemy 
#              weapon_damage = equipped_weapon.damage() # get weapon damage
#              attack_speed = equipped_weapon.get_attack_speed() / 1000.0 # get attack speed (milisecs)
              print(weapon_damage)
              body.take_damage(weapon_damage)
              print("hit enemy")
          attack_cooldown.start(attack_speed)
      else:
        # If its a crossbow/bow/ranged weapon -> instance arrows/bolts/projectiles
        if equipped_weapon.get_type() == "crossbow":
          weapon_model.bolt_damage = weapon_damage
          weapon_model.shoot()
          #attack_speed = equipped_weapon.get_attack_speed() / 1000.0
          attack_cooldown.start(attack_speed)
        #pass
  
  
  if move_vec.length() > 0 :
    speed = min(speed + acceleration * delta, max_speed)
    
    #Se já passou o cooldown e não está correndo -> regen stamina
    if $Stamina/StaminaRegenTimer.is_stopped() and not Input.is_action_pressed("sprint"):
      $Stamina.regen_stamina(4*delta)
      #print("Regen stamina")
      
  else:
    # quando nao esta se movendo olha para a posicao do mouse
    look_at_cursor()
    speed = max(speed - acceleration * delta, 0)
    #Se já passou o cooldown e não está se movendo -> regen stamina faster
    if $Stamina/StaminaRegenTimer.is_stopped():
      $Stamina.regen_stamina(8*delta)
      #print("Regen stamina")
    
      
  # Se está se movendo e correndo -> aumentar velocidade e usar stamina
  if move_vec.length() > 0 and Input.is_action_pressed("sprint") and $Stamina.get_stamina() > 0: # temporario, apenas para testar interface
      # olha na direcao do movimento 
      #$Model.look_at(global_transform.origin + move_vec, Vector3.UP)
      var new_yaw = atan2(-move_vec.x, -move_vec.z) # 0,2*PI
      var rot = Quat(Vector3(0.0, new_yaw, 0.0))
      var t = Quat($Model.transform.basis)
      var interp = t.slerp(rot, 0.2)
      $Model.transform.basis = Basis(interp)
      
      move_vec *= speed*1.5
      $Stamina.use_stamina(10*delta)
      $Stamina/StaminaRegenTimer.start(1) # cooldown até começar a regenerar (se parar de correr)
      #print("is sprinting")
      anim_tree.set("parameters/blend/blend_amount", 1) # esta correndo
  else:
    # se nao esta correndo player olha para a posicao do mouse
    look_at_cursor()
    anim_tree.set("parameters/blend/blend_amount", 0) # nao esta correndo
    move_vec *= speed # e velocidade normal

  if not $DetectGround.is_colliding():
    move_vec += Vector3.DOWN * GRAVITY * delta

  _velocity = move_vec
  _velocity = move_and_slide_with_snap(_velocity, Vector3.DOWN)
  
  _position = transform.origin
  emit_signal("position_changed", _position, _velocity)


func look_at_cursor():
  var player_pos = global_transform.origin
  var intersecPlane = Plane(Vector3.UP, player_pos.y) # para ficar no mesmo plano y do jogador (quando subir em algo)
  
  # Faz um ray cast e verifica onde intersecta no plano 
  var ray_length = 1000000
  var mouse_pos = get_viewport().get_mouse_position()
  var ray_origin = get_viewport().get_camera().project_ray_origin(mouse_pos)
  var ray_end = ray_origin + get_viewport().get_camera().project_ray_normal(mouse_pos) * ray_length
  cursor_pos = intersecPlane.intersects_ray(ray_origin, ray_end)
  
  if cursor_pos != null:
    # -z side/face of the model looks at position
    $Model.look_at(cursor_pos, Vector3.UP)
  
  $cursor.global_transform.origin = cursor_pos
  #print(cursor_pos)
  # se for usar cursor position para mirar com armas de longo alcance: 
  # cursor_pos = cursor_pos + Vector3(0,1,0)  #sobe a posição do cursor em 1 para que não fique no chão -> mirar com arcos
  

# instance new weapon and attack hitbox
func _on_Inventory_new_weapon_equipped(new_weapon, new_hitbox):
  if new_weapon != null:
    weapon_model = new_weapon.instance()
    if weapon_model != null: # and weapon.type == "melee"
      # Find and remove the old weapon model
      var old_model = get_tree().get_nodes_in_group("weapon_model")
      if not old_model.empty():
        #print(old_model)
        old_model[0].queue_free()
      
      # Insert the new weapon model
      $Model/Hand.add_child(weapon_model)
      #attack_hitbox = equipped_weapon.find_node("hitbox_pos").get_child(0) #get the hitbox of the weapon
      has_weapon = true
      
      var old_hitbox = get_tree().get_nodes_in_group("weapon_hitbox")
      if not old_hitbox.empty():
        old_hitbox[0].queue_free()
        
      if new_hitbox != null:
        var hitbox_node = new_hitbox.instance()
        $Model/MeleeHitbox.add_child(hitbox_node)
        attack_hitbox = hitbox_node.get_child(0) 
  

func _on_Health_you_died():
  print("You Died")
  

func _on_PlayerCamera_camera_rotation(current_rotation):
  camera_rotation = current_rotation
