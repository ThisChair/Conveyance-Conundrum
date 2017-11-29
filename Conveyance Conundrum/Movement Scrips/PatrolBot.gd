extends "StateLib.gd"

func _ready():
	var player = get_node("/root/StateTest/player")
	states = []
	states.append(IdleState.new())
	states.append(PursueState.new(get_parent(), player))
	var playerClose = TargetClose.new(get_parent(), player, 300)
	var playerHidden = TargetHidden.new(get_parent(), player)
	playerClose.setTargetState(states[1])
	playerHidden.setTargetState(states[0])
	states[0].setTransitions([playerClose])
	states[1].setTransitions([playerHidden])
	initialState = states[0]
	currentState = initialState
	set_fixed_process(true)

func _fixed_process(delta):
	run(delta)
