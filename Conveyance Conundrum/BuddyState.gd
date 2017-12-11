extends "res://Movement Scrips/StateLib.gd"

var called = false
var finished = false
var explore = false
var follow = false

func _ready():
	var player = get_node("/root/Demo/human")
	states = []
	states.append(IdleState.new())
	states.append(Called.new(get_parent(), player))
	states.append(Follow.new(get_parent(), player))
	states.append(Explore.new(get_parent(), player))
	var pathFollowCall = PathfollowCall.new(self)
	var followCall = FollowCall.new(self)
	var exploreCall = ExploreCall.new(self)
	var notMoving = NotMoving.new(get_parent())
	pathFollowCall.setTargetState(states[1])
	notMoving.setTargetState(states[0])
	followCall.setTargetState(states[2])
	exploreCall.setTargetState(states[3])
	states[0].setTransitions([pathFollowCall,exploreCall,followCall])
	states[1].setTransitions([notMoving,pathFollowCall,exploreCall,followCall])
	states[2].setTransitions([pathFollowCall,exploreCall,followCall])
	states[3].setTransitions([pathFollowCall,exploreCall,followCall])
	initialState = states[0]
	currentState = initialState
	initialState.getEntryAction()
	set_fixed_process(true)

func _fixed_process(delta):
	run(delta)