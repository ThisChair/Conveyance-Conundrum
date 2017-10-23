extends Node2D

# Implementation of a graph
# nodes : an array (linked list) of Nodes
# new_edge : a Edge object
# i : iterator variable
class Graph:
	
	var nodes = []
	var new_edge
	var i
	var j
	# Initialization parameters for the graph
	func _init(vertices):
		i = 0
		while i < vertices:
			nodes.append([])
			i += 1
	
	# Function to add a new connection
	# complete_edge : array of length == 3, where:
	# - complete_edge[0] = source node from which the edge leaves
	# - complete_edge[1] = weight of the edge
	# - complete_edge[2] = destination node to which the edge arrives
	func addConnection(complete_edge):
		
		var node = complete_edge[0]
		# Create an edge and add it to it's respective node
		new_edge = [complete_edge[1],complete_edge[2]]
		nodes[node].append(new_edge)
		
	# Prints the graph, the output has the structure:
	# 'source node -> destination node'
	func printGraph():
		i = 0
		while i < nodes.size():
			j = 0
			var edges = nodes[i]
			while j < edges.size():
				var edge = nodes[i][j]
				print(str(i)+" - > "+str(edge[1]))
				j += 1
			i += 1
	
	func getNodesAndEdges():
		return nodes
	
# Priority Queue implementation with Binary Heap
# Based on the code found in: 
# http://interactivepython.org/runestone/static/pythonds/Trees/BinaryHeapImplementation.html
# ----------------
# heapList : list containing all the elements in the heap
# currentSize : heap's current size
class PriorityQueue:
	
	var heapList
	var currentSize
	var hashmap 
	
	# Initialization parameters for the class
	# heapList's first element is a 0 which is not really used,
	# but useful for calculating a child's parent node later on
	func _init():
		heapList = [[0]]
		currentSize = 0
	
	# Percolates up the newly added node until it reaches it's
	# correct position to maintain the heap property
	func percUp(i):
		while floor(i/2) > 0:
			if heapList[i][0] < heapList[floor(i/2)][0]:
				var temp = heapList[floor(i/2)]
				heapList[floor(i/2)] = heapList[i]
				heapList[i] = temp
			i = floor(i/2)
	
	# Inserts a new node in queue
	func insert(k):
		heapList.append(k) 
		currentSize += 1
		percUp(currentSize)
	
	# Percolates down the new root node, resulting from eliminating 
	# the previous root, until it reaches it's correct position
	# to maintain the heap property
	func percDown(i):
		while (i * 2) <= currentSize:
			var mc = minChild(i)
			if heapList[i][0] > heapList[mc][0]:
				var temp = heapList[i]
				heapList[i] = heapList[mc]
				heapList[mc] = temp
				i = mc
	
	# Returns the minimum child of a node
	func minChild(i):
		if (i * 2) + 1 > currentSize:
			return i * 2
		else:
			if heapList[i*2][0] < heapList[i*2+1][0]:
				return i * 2
			else:
				return (i * 2) + 1
	
	# Deletes and returns the minimum child node, in our case
	# it represents the node with the highest priority
	# in the queue
	func delMin():
		var root = heapList[1]
		heapList[1] = heapList[currentSize]
		heapList.remove(currentSize-1)
		currentSize -= 1
		percDown(1)
		return root
		
	# Returns if our queue is currently empty
	func empty():
		return currentSize < 1
	
	# Prints the elements in the queue
	func printQueue():
		var i = 1
		while i <= currentSize:
			print(heapList[i])
			i += 1