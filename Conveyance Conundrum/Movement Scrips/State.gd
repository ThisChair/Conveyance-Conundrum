extends Node2D

var transitions = []

func getAction():
	pass

func getEntryAction():
	pass

func getExitAction():
	pass

func setTransitions(transitions):
	self.transitions = transitions

func getTransitions():
	return transitions