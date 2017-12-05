extends "graph.gd"

# Member variales
# Iteration variables
var i = 0
var j = 0
# Polygon variables
var triangle
var triangle_list = []
var centroid_list = []
# Color variables
var black = Color(0,0,0)
var vertex_colors = ColorArray()
# Graph variables
var graph
# Priority Queue variables
const INFINITY = 3.402823e+38

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	var child
	# Find the centroid of each triangle and save it 
	while (i < get_child_count()):
		
		# Iterate over all children nodes
		child = get_child(i)
		child.set_draw_behind_parent(true)
		child.hide()
		# Get the triangle
		triangle = child.get_polygon()
		# Add it to the list of triangles (for drawing later!)
		triangle_list.append(triangle)
		# Append the centroid to the centroids list
		centroid_list.append(findCentroidTriangle(triangle))
		i += 1
	
	# Create the edges...
	# ***REMINDER TO IMPROVE THIS***
	graph = Graph.new(centroid_list.size())
	var edges = [[0,1,1],[0,1,2],[1,1,2],[1,2,3],[3,1,4],[2,1,4],[4,1,5],[2,1,5],[3,1,6],[7,1,10],[10,1,11],[11,1,12],[7,1,8],[8,1,9],
	[7,1,6],[6,1,9],[12,1,13],[12,1,16],[13,1,14],[14,1,15],[15,1,17],[16,1,17],[15,1,16],[13,1,16],[14,1,16],[17,1,18],[18,1,19],
	[19,1,20],[20,1,21],[21,1,22],[22,1,23],[23,1,24],[24,1,25],[25,1,26],[26,1,27],[24,1,28],[25,1,29],[28,1,29],[24,1,29],[28,1,30],
	[30,1,31],[31,1,32],[32,1,33],[32,1,35],[33,1,34],[22,1,36],[23,1,36],[36,1,37],[37,1,38],[37,1,39],[39,1,40],[37,1,38],[38,1,39],
	[40,1,41],[41,1,42],[42,1,43],[40,1,44],[41,1,44],[44,1,45],[45,1,46],[46,1,47],[47,1,48],[48,1,49],[46,1,49],[49,1,50],[51,1,52],
	[51,1,35],[35,1,34],[35,1,52],[34,1,52],[51,1,34],[32,1,34],[35,1,33],[38,1,51],[52,1,53],[53,1,54],[53,1,55],[54,1,56],[55,1,47],
	[56,1,48],[47,1,56],[55,1,48],[55,1,54],[53,1,56],[33,1,57],[57,1,58],[59,1,61],[61,1,60],[60,1,62],[62,1,63],[58,1,59],[58,1,62],
	[54,1,64],[64,1,61],[64,1,66],[61,1,66],[61,1,65],[54,1,66],[66,1,65],[66,1,67],[68,1,69],[67,1,68],[69,1,70],[70,1,71],[71,1,72],
	[65,1,67],[72,1,73],[72,1,74],[73,1,75],[74,1,75],[74,1,73],[72,1,75],[74,1,76],[74,1,77],[76,1,77],[77,1,78],[78,1,79],[79,1,80],
	[81,1,82],[80,1,81],[82,1,83],[83,1,84]]
	
	var direction
	# Replace the default distance with the true distance
	for edge in edges:
		direction = centroid_list[edge[0]] - centroid_list[edge[2]]
		edge[1] = direction.length()
	
	# ...and add them to the graph
	i = 0
	while i < edges.size():
		graph.addConnection(edges[i])
		i += 1
	
	# _draw() should be drawing after the graph is made
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	# Press 'H' to hide the graph, 'G' to show
	if (Input.is_action_pressed("Hide_underlying_graph")):
		hide()
	elif (Input.is_action_pressed("Show_underlying_graph")):
		show()

# Finds the centroid of a given triangle
# tiangle : an array of points, representing the vertices of the triangle
func findCentroidTriangle(triangle):
	
	var L = triangle[0]
	var M = triangle[1]
	var N = triangle[2]
	
	return (L + M + N)/3

# Fun fuction for drawing all sorts of stuff, 
# all drawing submethods go here
func _draw():
	# Draws the triangles
	for triangle in triangle_list:
		# Draw each vertex connection
		for i in range(1,triangle.size()):
			draw_line(triangle[i-1],triangle[i],black,1)
		# Connect the last vertex to the first one
		draw_line(triangle[triangle.size()-1],triangle[0],black,1)
		
	# Draws the centroids of the triangles
	if (!centroid_list.empty()):
		for centroid in centroid_list:
			draw_circle(centroid,5,black)
			
	# Draws the graph's connections
	var nodes_and_edges = graph.getGraph()
	if (!nodes_and_edges.empty()):
		i = 0
		while i < nodes_and_edges.size():
			var edges = nodes_and_edges[i]
			for edge in edges:
				draw_line(centroid_list[i],centroid_list[edge[1]],black,3)
			i += 1

# Implementation of A*, for finding 
# the optimal path between two nodes in the graph
# start : initial node
# goal : destination goal
# graph : contains a 2d array with all the current connections in the graph
func A_Star(start,goal,graph):
	# The set of nodes already evaluated
	var closedSet = []
	
	# The set of currently discovered nodes that are not evaluated yet.
	# Initially, only the start node is known
	var openSet = PriorityQueue.new()
	
	# For each node, which node it can be most efficiently be reached from.
	# If a node can be reached from many nodes, cameFrom will eventually
	# contain the most efficient second step
	var cameFrom = []
	
	# For each node, the cost of getting from the start node to that node.
	# Initialized with a default value of infinity for all nodes
	var gScore = []
	var tentative_gScore
	
	# For each node, the total cost of getting from the start node to the
	# goal by passing by that node. That value is partly known, partly heuristic.
	# Initialized with a default value of infinity for all nodes
	var fScore = []
	
	# Initialization of gScore and fScore values for all nodes.
	var a = 0
	while a < graph.size():
		gScore.append(INFINITY)
		fScore.append(INFINITY)
		cameFrom.append(null)
		a += 1
	
	# The cost of going from start to start is zero.
	gScore[start] = 0
	
	# For the first node, fScore is completely heuristic.
	fScore[start] = heuristic_cost_estimate(start,goal)
	
	# Initially only the start node is in the open set
	start = [fScore[start],start]
	openSet.insert(start)
	
	# Current node
	var current

	while !openSet.empty():
		# Get the node with the highest priority in openSet (lowest fScore).
		var temp = openSet.delMin()
		current = temp[1]
		
		if current == goal:
			return reconstruct_path(cameFrom,current)
			
		# Node visited, add it to closed list.
		closedSet.append(current)
		
		# Check the neighbors of our current node.
		var edgeList = graph[current]
		for edge in edgeList:
			
			var weight = edge[0]
			var neighbor = edge[1]
			
			if closedSet.find(neighbor) != -1:
				continue # Ignore the neighbor which is already evaluated.
			
			# Search if our node is already in the open list.
			a = 1
			var found = false
			while a <= openSet.currentSize and !found: 
				if openSet.heapList[a][1] == neighbor: 
					found = true                    
				else:
					a += 1
			
			# The distance from start to a neighbor.
			tentative_gScore = gScore[current] + weight
			if tentative_gScore >= gScore[neighbor]:
				continue # This is not a better path.
			
			# This path is the best until now. Let's save it.
			cameFrom[neighbor] = current
			gScore[neighbor] = tentative_gScore
			fScore[neighbor] = gScore[neighbor] + heuristic_cost_estimate(neighbor,goal)
			
			if !found: # New node discovered, add it to open list.
				openSet.insert([fScore[neighbor],neighbor])
			
			# Reconstruct the binary heap property in case we lost it.
			if !openSet.empty():
				var currentHeaplist = openSet.heapList
				currentHeaplist.pop_front()
				openSet.heapList = []
				openSet.buildHeap(currentHeaplist) 
			
	# We failed to find a path from source to goal.
	return null

# Reconstructs the optimal path using 
# the pointers of each node in the list cameFrom
# cameFrom : pointers describing for each node, which node it can be most efficiently be reached from
# current : current node
func reconstruct_path(cameFrom,current):
	
	# Container for the path.
	var total_path = [current]
	var x = 0
	
	# Reconstruct the path from the pointers in the list.
	while x < cameFrom.size() and current != null:
		current = cameFrom[current]
		total_path.append(current)
		x += 1
		
	# Invert the path for easy printing later.
	total_path.invert()
	
	return total_path

# Heuristic function to predict the optimal path.
# Current heuristic in use: Euclidean Distance
# from : source node
# to : destination node
func heuristic_cost_estimate(from,to):
	
	var vector0 = centroid_list[from]
	var vector1 = centroid_list[to]
	
	var a = vector0.x - vector1.x
	var b = vector0.y - vector1.y
	
	return sqrt(pow(a,2)+pow(b,2))

# Prints a list of nodes representing a given path
# path : an array of nodes describing a path
func printPath(path):
	
	if path != null:
		for node in path:
			print(node)
	else:
		print("A* could not find a path in the graph")
		
# Calculate optimal path
func optimalPath(initial,final):
	
	var optimal_path = []
		# Calculate the optimal path using A*
	optimal_path = A_Star(initial,final,graph.getGraph())
	optimal_path.pop_front()
	
	# Replace the nodes with their respective positions in the map
	for i in range(optimal_path.size()):
		optimal_path[i] = centroid_list[optimal_path[i]]

	return optimal_path