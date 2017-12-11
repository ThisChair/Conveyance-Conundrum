extends "kinematic.gd"

# Lists of states
var states = []

# Initial state
var initialState

# Current state
var currentState

func run(delta):
	
	var triggeredTransition
	currentState.getAction()
	for transition in currentState.getTransitions():
		if transition.isTriggered():
			triggeredTransition = transition
			break
	
	if triggeredTransition:
		var targetState = triggeredTransition.getTargetState()
		
		currentState.getExitAction()
		triggeredTransition.getAction()
		targetState.getEntryAction()
		
		currentState = targetState