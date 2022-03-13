class_name WanderSteering extends BaseSteeringBehavior

var wander_jitter = 50
var wander_radius = 2
var wander_distace = 5
var wander_target = Vector3.ZERO

var rng = RandomNumberGenerator.new()

func _init():
  rng.randomize()

func very_smal_random_float():
  return rng.randf() - rng.randf()

func _behavior_type():
  return "wander"

func _calculate(entity: Entity, delta: float, _params):
  var jitter_amount = wander_jitter * delta

  # first, add a small random vector to the target's position
  wander_target += Vector3(very_smal_random_float(), 0, very_smal_random_float()) * jitter_amount

  # reproject this new vector back on to a unit circle
  wander_target = wander_target.normalized()

  # increase the length of the vector to the same as the radius
  # of the wander circle
  wander_target *= wander_radius

  # move the target into a position WanderDist in front of the agent
  var target = wander_target + Vector3.FORWARD * wander_distace

  # project the target into world space
  target = entity.to_global(target)

  #and steer towards it
  return target - entity.transform.origin; 
  
