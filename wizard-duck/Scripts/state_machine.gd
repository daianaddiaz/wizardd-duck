class_name StateMachine extends Node

var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		states[child.name]= child
		child.finished_state.connect(to_transition)
		child.player = get_parent()
		
func _physics_process(_delta):
	if current_state:
		current_state.pysics_update(_delta)
		
func _unhandled_input(_event):
	if current_state:
		current_state.handle_Imput(_event)
		
	
func to_transition(new_state: State):
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()
