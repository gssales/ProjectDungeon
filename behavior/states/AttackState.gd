class_name AttackState extends BaseState

var steer_node : Steering
var timer = 0 
var COOLDOWN = 1
var vision : LineOfSight

func _enter(entity: Entity):
  vision = entity.get_node("LineOfSight")
  steer_node = entity.get_node("Steering")
  var SeekSteering = load("res://behavior/steering/SeekSteering.gd")
  steer_node.current_behavior = SeekSteering.new()
  entity.max_speed = 2
  
func _execute(entity: Entity, delta: float):
  timer += delta
  
  var seen = vision._look()
  if seen == null:
    entity.target_foe = null   
  else:
    entity.target_foe = seen
  
  if entity.target_foe == null:
    var behavior = entity.get_node("Behavior")
    var LookOutState = load("res://behavior/states/LookOutState.gd")
    behavior.change_state(LookOutState.new())
  
  var distance_to_foe = entity.transform.origin.distance_to(steer_node.target_position)
  if distance_to_foe > 5:
    var behavior = entity.get_node("Behavior")
    var FollowState = load("res://behavior/states/FollowState.gd")
    behavior.change_state(FollowState.new())      
  
  var ray_cast = entity.get_node("RayCast")
  if ray_cast.is_colliding():
    var body = ray_cast.get_collider()
    if body.is_in_group("player"):
      if timer >= COOLDOWN:
        body.get_node("Health").take_damage(10)
        timer = 0
        
func _exit(entity: Entity):
  pass
