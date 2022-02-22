extends Node

var rand = RandomNumberGenerator.new()

var _type
var _name
var _range
var damageRange

func init(params):
  self._type = params._type
  self._name = params._name
  self._range = params._range
  self.damageRange = params.damageRange

func damage(multiplier = 1):
  var damage = rand.randf_range(damageRange[0], damageRange[1])
  print(damage * multiplier)
