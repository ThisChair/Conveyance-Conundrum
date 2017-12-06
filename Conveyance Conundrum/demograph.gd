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
	# ***REMINDER TO IMPROVE THIS*** Or not(?).
	graph = Graph.new(centroid_list.size())
	var edges = [
		[0,1,1], 
		[1,1,2], [1,1,3], 
		[2,1,3], [2,1,4], 
		[3,1,4], [3,1,6], 
		[4,1,5], 
		[6,1,117], [6,1,118], 
		[7,1,10], [7,1,8], 
		[8,1,9], 
		[9,1,222], [9,1,111], 
		[10,1,119], [10,1,120], 
		[7,1,117], 
		[9,1,118], 
		[11,1,12], [11,1,119], [11,1,120], 
		[12,1,121], [12,1,122], 
		[13,1,14], [13,1,16], [13,1,121], 
		[14,1,15], [14,1,116], 
		[15,1,16], [15,1,127], 
		[16,1,123], [16,1,124], 
		[17,1,18], [17,1,126], [17,1,127], 
		[18,1,128], [18,1,129], 
		[19,1,20], [19,1,128], [19,1,129], 
		[20,1,21], [20,1,130], 
		[21,1,22], [21,1,130], 
		[22,1,23], [22,1,135], 
		[23,1,24], [23,1,36], 
		[24,1,131], [24,1,134], 
		[25,1,29], [25,1,131], 
		[25,1,26], 
		[26,1,132], [26,1,133], 
		[27,1,132], [27,1,133], 
		[28,1,29], [28,1,30], [28,1,134], 
		[30,1,145], [30,1,146], 
		[31,1,145], [31,1,146], 
		[31,1,32], 
		[32,1,35], [32,1,151], 
		[33,1,34], [33,1,57], [33,1,151], 
		[34,1,35], [34,1,150], 
		[35,1,147], 
		[36,1,37], [36,1,135], 
		[37,1,39], [37,1,144], 
		[38,1,39], [38,1,144], [38,1,51], 
		[39,1,40], 
		[40,1,138], [40,1,140], 
		[41,1,42], [41,1,138], [41,1,139], 
		[42,1,136], [42,1,137], 
		[43,1,136], [43,1,137], 
		[44,1,45], [44,1,139], [44,1,140], 
		[45,1,141], [45,1,142], 
		[46,1,47], [46,1,141], [46,1,142], 
		[47,1,55], [47,1,143], 
		[48,1,49], [48,1,56], [48,1,143], 
		[49,1,163], [49,1,164], 
		[50,1,163], [50,1,164], 
		[51,1,147], [51,1,148], 
		[52,1,53], [52,1,148], [52,1,150], 
		[53,1,149], [53,1,154], 
		[54,1,64], [54,1,154], [54,1,155], 
		[55,1,56], [55,1,149], 
		[56,1,155], 
		[57,1,152], [57,1,153], 
		[58,1,152], [58,1,153], [58,1,59], 
		[59,1,159], [59,1,160], 
		[60,1,62], [60,1,158], [60,1,160], 
		[61,1,156], [61,1,157], [61,1,158], [61,1,159], 
		[62,1,161], [62,1,162], 
		[63,1,161], [63,1,162], 
		[64,1,66], [64,1,156], 
		[65,1,66], [65,1,67], [65,1,157], 
		[67,1,68], [67,1,165], 
		[68,1,69], [68,1,165], 
		[69,1,166], [69,1,167], 
		[70,1,71], [70,1,166], [70,1,167], 
		[71,1,168], [71,1,169], 
		[72,1,168], [72,1,169], [72,1,170], [72,1,171], 
		[73,1,74], [73,1,170], [73,1,173], 
		[74,1,171], [74,1,172], 
		[75,1,173], [75,1,186], 
		[76,1,100], [76,1,174], [76,1,177], 
		[77,1,174], [77,1,177], [77,1,78], 
		[78,1,175], [78,1,178], 
		[79,1,80], [79,1,175], [79,1,178], 
		[80,1,179], [80,1,180], 
		[81,1,82], [81,1,179], [81,1,180], 
		[82,1,181], [82,1,185], [82,1,184], 
		[83,1,84], [83,1,184], [83,1,185], 
		[84,1,187], [84,1,188], 
		[85,1,86], [85,1,187], [85,1,188], 
		[86,1,87], [86,1,189], 
		[87,1,88], [87,1,189], 
		[88,1,190], [88,1,191], 
		[89,1,90], [89,1,190], [89,1,191], 
		[90,1,192], [90,1,193], 
		[91,1,93], [91,1,192], [91,1,193], 
		[92,1,193], [92,1,194], [92,1,201], [92,1,202], 
		[93,1,194], [93,1,199], 
		[94,1,95], [94,1,194], [94,1,199], 
		[95,1,197], [95,1,198], [95,1,200], 
		[96,1,97], [96,1,197], [96,1,198], 
		[97,1,195], [97,1,196], 
		[98,1,99], [98,1,195], [98,1,196], 
		[99,1,100], [99,1,176], 
		[100,1,176], 
		[101,1,112], [101,1,201], [101,1,210], 
		[102,1,103], [102,1,202], [102,1,210], 
		[103,1,211], [103,1,212], 
		[104,1,105], [104,1,211], [104,1,212], 
		[105,1,213], [105,1,214], 
		[106,1,213], [106,1,214], [106,1,215], 
		[107,1,108], [107,1,216], [107,1,217], 
		[108,1,218], [108,1,219], 
		[109,1,218], [109,1,219], 
		[109,1,110], [109,1,221], 
		[110,1,111], [110,1,221], 
		[111,1,220], [111,1,222], 
		[112,1,208], [112,1,209], 
		[113,1,207], [113,1,208], [113,1,209], 
		[114,1,205], [114,1,206], [114,1,207], 
		[115,1,203], [115,1,204], [115,1,205], 
		[116,1,203], [116,1,204], 
		[122,1,123], 
		[123,1,125], 
		[124,1,125], [124,1,126], 
		[171,1,174], 
		[172,1,174], 
		[181,1,182], [181,1,183], 
		[183,1,184], 
		[215,1,216]
	]
	
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
# Find the triangle for any given position
func findTriangle(position):
	var distance = INFINITY
	var result
	var v
	for i in range(centroid_list.size()):
		v = centroid_list[i] - position
		if v.length() < distance:
			distance = v.length()
			result = i
	return result