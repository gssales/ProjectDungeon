class_name Enemy extends Entity

export(float) var maxhealth = 35
var health = 0

var mass = 1

var line_of_sight_state = {
  "foe_on_sight": false,
  "distance_to_foe": 1e10,
  "foe_position": Vector3.ZERO
 }

var can_attack = true
var may_attack = false
var attk_timer
var attk_delay = 1
onready var attack_hitbox = $AttackHitbox/Area
var damage = [0,5]

onready var anim_tree = $CSGMesh/bug/AnimationTree

func _ready():
  max_speed = 2
  _velocity = Vector3.ZERO
  _heading = Vector3.FORWARD
  $DetectGround.enabled = true
  health = maxhealth
  
  attk_timer = Timer.new() #attack timer
  add_child(attk_timer)
  attk_timer.one_shot = true
  attk_timer.wait_time = attk_delay
  
  anim_tree.active = true
  
  #warning-ignore-all:return_value_discarded
  $WallSensor.connect("wall_detected", self, "_on_WallSensor_wall_detected")
  $LineOfSight.looking_for_groups.push_back("player")
  $LineOfSight.looking_for_groups.push_back("ally")
  $LineOfSight.connect("update_closest_entity", self, "_on_LineOfSight_update_closest_entity")
  
  var WanderState = load("res://behavior/states/enemy_fsm/WanderState.gd")
  $Behavior._on_BehaviorState_change_state(WanderState.new())

func _physics_process(delta):
  if health <= 0:
    anim_tree.set("parameters/dying/active", true)
    $CollisionShape.set_deferred("disabled", true)
    
    var time_in_seconds = 1
    var die_timer = Timer.new()
    die_timer.wait_time = time_in_seconds
    die_timer.one_shot = true
    self.add_child(die_timer)
    die_timer.start()
    
    yield(die_timer, "timeout")
    # error resume: resumed function '_physics_process()' after yield, but class instance is gone. 
    #  at script: res://entities/enemy_1/enemy.gd:50
    # yield(get_tree().create_timer(time_in_seconds), "timeout") 
    die_timer.queue_free()
    queue_free()
    
    #die()
    
    
  if do_rotate:
    var rot = (rotation_rad + rotated_rad) * delta * -1
    _heading = _heading.rotated(Vector3.UP, rot)
    look_at(transform.origin + _heading, Vector3.UP)
    
    rotated_rad += rot
    if abs(rotation_rad + rotated_rad) <= 0.001:
      do_rotate = false
    
  $LineOfSight.update(delta)
  $WallSensor.update(delta)
  
  $Behavior.update(delta)
  
  var snap_vector = Vector3.DOWN
  
  if not $DetectGround.is_colliding():
    _velocity += Vector3.DOWN * 9.88 * delta
  else:
    snap_vector = -$DetectGround.get_collision_normal()
    # calculate force
    var steering_force = $Steering.calculate(delta, steering_params)
    # calculate acceleration
    var acceleration = steering_force / mass
    # velocity 
    _velocity += acceleration * delta
        
  if _velocity.length() > max_speed:
    _velocity = _velocity.normalized() * max_speed
    
  if Vector2(_velocity.x, _velocity.z).length() > 0.000001:
    _heading = Vector3(_velocity.x, 0, _velocity.z).normalized() * 4
    look_at(transform.origin + _heading, Vector3.UP)
    anim_tree.set("parameters/idle_walk/blend_amount", 1)
  else :
    anim_tree.set("parameters/idle_walk/blend_amount", 0)
    
  _velocity = move_and_slide_with_snap(_velocity, snap_vector, Vector3.DOWN)
  
  # Enemy attack
  if may_attack and attk_timer.is_stopped():
    anim_tree.set("parameters/attack/active", true)
    for body in attack_hitbox.get_overlapping_bodies():
      var d = rand_range(damage[0], damage[1])
      if body.is_in_group("player"):
        #print("attacking player")
        body.get_node("Health").take_damage(d)
      
      elif body.is_in_group("ally"):
        body.take_damage(d)
      
      attk_timer.start(attk_delay)

func die():
  var c = load("res://player/lw_polly_char.tscn")
  var body = c.instance()
  get_parent().add_child(body)
  body.transform = body.transform.scaled(Vector3(2,2,2)).rotated(Vector3.UP, PI +rotation.y)
  body.transform.origin = transform.origin
  body.body_sim()
  queue_free()

func take_damage(amount):
  if !$DamageSFX.is_playing():
    $DamageSFX.play()
  health -= amount
  if health < 0:
    health = 0 

func _on_LineOfSight_update_closest_entity(entity):
  #if entity != null and not entity.is_queued_for_deletion() and is_instance_valid(entity):
  if entity != null and is_instance_valid(entity):
    line_of_sight_state.foe_on_sight = true
    line_of_sight_state.distance_to_foe = get_position().distance_to(entity.global_transform.origin)
    line_of_sight_state.foe_position = entity.global_transform.origin
  else:
    line_of_sight_state.foe_on_sight = false
    line_of_sight_state.distance_to_foe = 1e10

func _on_WallSensor_wall_detected(wall_detected):
  steering_params["wall_detected"] = wall_detected


func _on_AttackState_entity_attack(entity):
  if entity == self:
    may_attack = true
    #print(self, "can_attack")
    attk_timer.start(attk_delay) 

func _on_AttackState_entity_cannot_attack(entity):
  if entity == self:
    may_attack = false
    #print(self, "cannot_attack")
    attk_timer.start(attk_delay)
