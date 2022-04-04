class_name BaseState extends Object

#warning-ignore-all:unused_signal
signal change_state(new_state)
signal change_steering(new_steering)
signal change_entity(params)

func _enter(_entity: Entity):
  assert(false, "Method not implemented")
  
func _execute(_entity: Entity, _delta: float):
  assert(false, "Method not implemented")
  
func _exit(_entity: Entity):
  assert(false, "Method not implemented")
