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
  
func init(params):
  self._type = params._type
  self._name = params._name
  self._range = params._range
  self.damageRange = params.damageRange
  self.params = params
  self.weapon_model = params.weapon_model
  self.attack_speed = params.attack_speed
  self.hitbox = params.hitbox

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
