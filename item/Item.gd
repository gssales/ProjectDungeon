extends Node

var rand = RandomNumberGenerator.new()

var _type
var _name
var _range
var damageRange
var params
export(PackedScene) var weapon_model
export(PackedScene) var hitbox
var attack_speed
  
func init(new_params):
  self._type = new_params._type
  self._name = new_params._name
  self._range = new_params._range
  self.damageRange = new_params.damageRange
  self.params = new_params
  self.weapon_model = new_params.weapon_model
  self.attack_speed = new_params.attack_speed
  self.hitbox = new_params.hitbox

func damage(multiplier = 1):
  var damage = (randf() * (damageRange[1] - damageRange[0])) + damageRange[0]
  print(damage * multiplier)
  return damage

func get_weapon_model():
  return weapon_model

func get_hitbox():
  return hitbox

func get_attack_speed():
  return attack_speed

func get_type():
  return _type
