extends Node

var Torch = preload("res://rooms/props/Torch.tscn")
var rng = RandomNumberGenerator.new()
var noise = OpenSimplexNoise.new()
var lights_node

func _ready():
  pass
  
func generate_lights(matrix):
  rng.randomize()
  lights_node = Spatial.new()
  for x in range(matrix.size()):
    for y in range(matrix[x].size()):
      var room = matrix[x][y]
      if room == null:
        continue
#      var prob = rng.randfn(0.40, 0.25)
      var prob = noise.get_noise_2d(x/2, y/2)
      if room.is_in_group("room"):
        light_room(prob, room)
      elif room.is_in_group("corridor"):
        light_corridor(prob, room)
  return lights_node

func light_room(prob, room):
  if room.portal_up:
    add_torch_maybe(prob, room.translation + Vector3(-8,4.5,-16))
    add_torch_maybe(prob, room.translation + Vector3(8,4.5,-16))
  else:
    add_torch_maybe(prob, room.translation + Vector3(-12,4.5,-16))
    add_torch_maybe(prob, room.translation + Vector3(-2,4.5,-16))
    add_torch_maybe(prob, room.translation + Vector3(7,4.5,-16))
    
  if room.portal_down:
    add_torch_maybe(prob, room.translation + Vector3(-8,4.5,16), PI)
    add_torch_maybe(prob, room.translation + Vector3(8,4.5,16), PI)
  else:
    add_torch_maybe(prob, room.translation + Vector3(-12,4.5,16), PI)
    add_torch_maybe(prob, room.translation + Vector3(-6,4.5,16), PI)
    add_torch_maybe(prob, room.translation + Vector3(11,4.5,16), PI)
    
  if room.portal_left:
    add_torch_maybe(prob, room.translation + Vector3(-16,4.5,-8), PI/2)
    add_torch_maybe(prob, room.translation + Vector3(-16,4.5,8), PI/2)
  else:
    add_torch_maybe(prob, room.translation + Vector3(-16,4.5,-12), PI/2)
    add_torch_maybe(prob, room.translation + Vector3(-16,4.5,-2), PI/2)
    add_torch_maybe(prob, room.translation + Vector3(-16,4.5,7), PI/2)
    
  if room.portal_right:
    add_torch_maybe(prob, room.translation + Vector3(16,4.5,-8), -PI/2)
    add_torch_maybe(prob, room.translation + Vector3(16,4.5,8), -PI/2)
  else:
    add_torch_maybe(prob, room.translation + Vector3(16,4.5,-12), -PI/2)
    add_torch_maybe(prob, room.translation + Vector3(16,4.5,-2), -PI/2)
    add_torch_maybe(prob, room.translation + Vector3(16,4.5,7), -PI/2)

func add_torch_maybe(prob, position, rotation = 0):
  prob = noise.get_noise_2d(position.x/4, position.z/4)
  if 0 < prob:
    lights_node.add_child(new_torch(position, rotation))
      
func new_torch(position, rotation = 0):
  var t = Torch.instance()
  t.translate(position)
  t.rotate_y(rotation)
  return t
  
func light_corridor(prob, corridor):
  if corridor.portal_up:
    add_torch_maybe(prob, corridor.translation + Vector3(-3,4.5,-12), PI/2)
    add_torch_maybe(prob, corridor.translation + Vector3(3,4.5,-8), -PI/2)
    
  if corridor.portal_down:
    add_torch_maybe(prob, corridor.translation + Vector3(-3,4.5,4), PI/2)
    add_torch_maybe(prob, corridor.translation + Vector3(3,4.5,8), -PI/2)
    
  if corridor.portal_left:
    add_torch_maybe(prob, corridor.translation + Vector3(-12,4.5,-3))
    add_torch_maybe(prob, corridor.translation + Vector3(-8,4.5,3), PI)
    
  if corridor.portal_right:
    add_torch_maybe(prob, corridor.translation + Vector3(7,4.5,-3))
    add_torch_maybe(prob, corridor.translation + Vector3(10,4.5,3), PI)
