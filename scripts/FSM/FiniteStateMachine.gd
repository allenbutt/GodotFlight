extends Node
class_name FiniteStateMachine

var states : Dictionary = {}
var current_state : State
@export var initial_state : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _physics_process(delta):
	if current_state and Global.alive:
		current_state.Update(delta)

func change_state(source_state : State, new_state_name : String):
	#Error Checking
	if source_state != current_state:
		print("Invalid change_state trying from: " + source_state.name + "currently in " + current_state.name)
		return
	#Get new state
	var new_state = states.get(new_state_name.to_lower())
	#Error Checking
	if !new_state:
		print("New state is empty")
		return
	#Exit current state, enter new state
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
