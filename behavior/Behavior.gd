extends Node

var FollowState = load("res://behavior/states/FollowState.gd")

var current_state = FollowState.new()

func _ready():
  pass
  
func update(delta):
  current_state._execute(get_parent())

func change_state(NewState):
  current_state._exit(get_parent())
  
  current_state = NewState.new()
  
  current_state._enter(get_parent())
