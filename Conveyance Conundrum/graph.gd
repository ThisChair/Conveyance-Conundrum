extends Node2D

# Implementation of a graph
# nodes : a 2D array representing the graph structure
# node : holds source node of our current complete edge
# new_edge : represents an edge of the form [weight,dest_node]
# inv_edge : necessary for adding a two way connection
# i and j : iterator variables
class Graph:
	
	var nodes = []
	var source
	var dest
	var new_edge
	var inv_edge
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
		
		source = complete_edge[0]
		dest = complete_edge[2]
		# Create an edge and add it to it's respective node
		new_edge = [complete_edge[1],dest]
		nodes[source].append(new_edge)
		# For every edge we add, we must add an edge in the opposite
		# direction
		inv_edge = [complete_edge[1],source]
		nodes[dest].append(inv_edge)
		
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
	
	# Returns a 2d array with the graph's structure
	func getGraph():
		return nodes
	
# Priority Queue implementation with Binary Heap
# Based on the code found in: 
# http://interactivepython.org/runestone/static/pythonds/Trees/BinaryHeapImplementation.html
# This queue handles objects of the form [weight,node], where:
# weight : is the weight of the node
# node : is the node to where the edge containing the previously mentioned weight arrives
# This means this priority queue sorts according to edge weight, which is what we want. 
# ----------------
# heapList : list containing all the elements in the heap
# currentSize : heap's current size
class PriorityQueue:
	
	var heapList
	var currentSize
	
	# Initialization parameters for the class
	# heapList's first element is a 0 which is not really used,
	# but useful for calculating a child's parent node later on
	func _init():
		self.heapList = [[0]]
		self.currentSize = 0
	
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
		heapList.pop_back()
		currentSize -= 1
		percDown(1)
		return root
	
	# Construcs a binary heap from a given list,
	# normally used in A* for recovering the binary heap
	# property after updating the weight values of a node
	# already present in the heap.
	func buildHeap(aList):
		var v = floor(aList.size() / 2)
		self.currentSize = aList.size()
		aList.push_front([0])
		self.heapList = aList
		while (v > 0):
			percDown(v)
			v -= 1
		
	# Returns if our queue is currently empty
	func empty():
		return currentSize < 1
	
	# Prints the elements in the queue
	func printQueue():
		var i = 1
		while i <= currentSize:
			print(heapList[i])
			i += 1