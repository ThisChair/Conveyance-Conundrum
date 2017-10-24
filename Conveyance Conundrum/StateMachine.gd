extends Node2D

# Lists of states
var states

# Initial state
var initialState

# Current state
var currentState

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _update():
	
	var triggeredTransition
	
	for transition in currentState.getTransitions():
		if transition.isTriggered():
			triggeredTransition = transition
			break
	
	if triggeredTransition:
		targetState = triggeredTransition.getTargetState()
		
		currentState.getExitAction()
		triggeredTransition.getAction()
		targetState.getEntryAction()
		
		currentState = targetState
	else:
		currentState.getAction()