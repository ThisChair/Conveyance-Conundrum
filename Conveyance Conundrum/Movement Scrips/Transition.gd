extends Node2D

var targetState

func isTriggered():
	return false

func setTargetState(state):
	self.targetState = state

func getTargetState():
	return targetState

func getAction():
	pass