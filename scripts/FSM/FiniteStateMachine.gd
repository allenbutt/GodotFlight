extends Node
class_name FiniteStateMachine

var states : Dictionary = {}
var current_state : State
@export var initial_state : State

func _ready():
	current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)
