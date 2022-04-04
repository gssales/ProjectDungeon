extends OmniLight

var rng = RandomNumberGenerator.new()
var extra_energy = 0

var timer = 1
var time_elapsed = 0

func very_small_random_float():
  return rng.randf() - rng.randf()

func _ready():
  rng.randomize()
  
func _process(delta):
  time_elapsed += delta
  if time_elapsed >= timer:
    time_elapsed = 0
    light_energy = sin(rng.randf())/2 + 1
    timer = rng.randf_range(0.05, 0.2)
