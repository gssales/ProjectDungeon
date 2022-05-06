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

onready var hand = $Model/lw_polly_char_v5/game_rig/Skeleton/Hand
onready var anim_tree = $Model/lw_polly_char_v5/AnimationTree

func _ready():
  $Camera.look_at(self.transform.origin, Vector3.UP)
  anim_tree.active = true
  
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
  if not (anim_tree.get("parameters/run_blend/blend_amount") == 1) and Input.is_action_pressed("attack") and attack_cooldown.is_stopped():
    
    # If its a sword / melee type weapon -> use hitbox
    if equipped_weapon != null:
      weapon_damage = equipped_weapon.damage() # get weapon damage
      attack_speed = equipped_weapon.get_attack_speed() / 1000.0 # get attack speed (milisecs)
      if equipped_weapon.get_type() == "espada":
        if attack_hitbox != null: # depois fazer a hitbox ficar ativa somente por um periodo de tempo
          play_slash_anim(attack_speed)
          for body in attack_hitbox.get_overlapping_bodies(): # search for entities in attack hittbox
            if body.is_in_group("Enemy"): #if it is an enemy 
              print(weapon_damage)
              body.take_damage(weapon_damage)
              print("hit enemy")
          attack_cooldown.start(attack_speed)
      else:
        # If its a crossbow/bow/ranged weapon -> instance arrows/bolts/projectiles
        if equipped_weapon.get_type() == "crossbow":
          weapon_model.bolt_damage = weapon_damage
          weapon_model.shoot()
          attack_cooldown.start(attack_speed)
  
  
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
      anim_tree.set("parameters/run_blend/blend_amount", 1) # esta correndo
  else:
    # se nao esta correndo player olha para a posicao do mouse
    look_at_cursor()
    anim_tree.set("parameters/run_blend/blend_amount", 0) # nao esta correndo
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
  

func play_slash_anim(attack_speed):
  # 0.708 == duração da animação
  var scale = 0.708 / attack_speed
  
  anim_tree.set("parameters/slash_speed/scale", scale)
  anim_tree.set("parameters/sword_slash/active", true)


func set_weapon_anim():
  var weapon_type = equipped_weapon.get_type()
  
  if weapon_type == "espada":
    anim_tree.set("parameters/walk_hsword/blend_amount", 1)
    anim_tree.set("parameters/run_hsword/blend_amount", 1)
    anim_tree.set("parameters/walk_hcrossbow/blend_amount", 0)
    anim_tree.set("parameters/run_hcrossbow/blend_amount", 0)
    
  elif weapon_type == "crossbow":
    anim_tree.set("parameters/walk_hsword/blend_amount", 0)
    anim_tree.set("parameters/run_hsword/blend_amount", 0)
    anim_tree.set("parameters/walk_hcrossbow/blend_amount", 1)
    anim_tree.set("parameters/run_hcrossbow/blend_amount", 1)


# set weapon position in relation to hand and adjust size (if needed)
func set_weapon_pos(weapon:Spatial, weapon_params):
  if weapon != null:
    var type = equipped_weapon.get_type()
    if type == "espada":
      weapon.transform = Transform(Vector3(0.866, -2.294, -0.488), 
                                  Vector3(-0.913, 0.149, -2.322),
                                  Vector3(2.16, 0.983, -0.786),
                                  Vector3(0.038, 0.411, -0.22)
                          )
      #print(weapon.transform)
      weapon.translation = Vector3(0.038, 0.411, -0.22)
      weapon.rotation_degrees = Vector3(-23.144, 109.998, -86.272)
      weapon.scale = Vector3(2.5, 2.5, 2.5)
      
    elif type == "crossbow":
      weapon.transform = Transform(Vector3(-0.882, -0.329, 0.337), 
                                  Vector3(-0.385, 0.092, -0.918),
                                  Vector3(0.271, -0.94, -0.208),
                                  Vector3(-0.308, 1.277, -0.348)
                          )
      #print(weapon.transform)
      weapon.translation = Vector3(-0.308, 1.277, -0.348)
      weapon.rotation_degrees = Vector3(70.004, 127.459, -74.369)
      weapon.scale = Vector3(1, 1, 1)


# instance new weapon and attack hitbox
func _on_Inventory_new_weapon_equipped(new_weapon, new_hitbox):
  if new_weapon != null:
    weapon_model = new_weapon.instance()
    
    if weapon_model != null: 
      # get weapon ready to be equipped
      if inventory.get_child_count() != 0:
        equipped_weapon = inventory.get_child(0)
        set_weapon_pos(weapon_model, equipped_weapon)
        set_weapon_anim()
        #attack_cooldown.start(0.3) # cooldown between switching weapons
        #print("weapon set")
        
      # Find and remove the old weapon model
      var old_model = get_tree().get_nodes_in_group("weapon_model")
      if not old_model.empty():
        #print(old_model)
        old_model[0].queue_free()
      
      # Insert the new weapon model
      #$Model/Hand.add_child(weapon_model)
      hand.add_child(weapon_model)
#      if inventory.get_child_count() != 0:
#        equipped_weapon = inventory.get_child(0)
#        var weap = hand.get_child(0)
#        set_weapon_pos(weap, equipped_weapon)
#        set_weapon_anim()
#        print("weapon set")
      
      # set timer to be used for weapon attack speed
      attack_cooldown = weapon_model.get_node("AttkTimer") as Timer
      attack_cooldown.one_shot = true
      
      var old_hitbox = get_tree().get_nodes_in_group("weapon_hitbox")
      if not old_hitbox.empty():
        old_hitbox[0].queue_free()
        
      if new_hitbox != null:
        var hitbox_node = new_hitbox.instance()
        $Model/MeleeHitbox.add_child(hitbox_node)
        attack_hitbox = hitbox_node.get_child(0) 
  

func _on_Health_you_died():
  #print("You Died")
  pass
  

func _on_PlayerCamera_camera_rotation(current_rotation):
  camera_rotation = current_rotation
