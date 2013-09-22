package titanium_reindeer.ai.pathing;

class WeightedNode
{
	public var node:PathNode;
	public var opened:Bool;
	public var closed:Bool;

	public var f:Float;
	public var g:Float;
	public var h:Float;

	public function new(node:PathNode)
	{
		this.opened = false;
		this.closed = false;
		this.node = node;

		this.f = 0;
		this.g = 0;
		this.h = 0;
	}

	public function open()
	{
		this.opened = true;
	}

	public function close()
	{
		this.opened = false;
		this.closed = true;
	}

	public static function sort(a:WeightedNode, b:WeightedNode):Int
	{
		return a.f - b.f;
	}
}

class RoutingAlgorithms
{
	public static function aStar(start:PathNode, end:PathNode, graph:IPathNodeGraph):Array<PathNode>
	{
		var openList:Array<WeightedNode> = new Array();
		var heuristic = this.heuristic;
		var weight = this.weight;
		var pathSoFar:Array<WeightedNode> = new Array();
		var SQRT2:Float = Math.sqrt(2);

		var nodeMap:Map<String, WeightedNode> = new Map();
		var getWeighted:PathNode -> WeightedNode = function (node:PathNode) {
			var key:String = node.x+","+node.y;
			if (!nodeMap.exists(key))
				nodeMap.set(key, new WeightedNode(node));
			return nodeMap.get(key);
		};

		// push the start node into the open list
		var startNode:WeightedNode = getWeighted(start);
		openList.push(startNode);
		startNode.open();

		// while the open list is not empty
		while (openList.length > 0)
		{
			// pop the position of node which has the minimum `f` value.
			var wNode = openList.pop();
			wNode.close();

			// if reached the end position, construct the path and return it
			if (wNode.node == end) {
				pathSoFar.push(wNode.node);
				return pathSoFar;
			}

			// get neigbours of the current node
			var neighbors:Array<PathNode> = graph.getAdjacentNodes(wNode.node);
			for (var pNode:PathNode in neighbors)
			{
				var neighbor = getWeighted(pNode);
				if (neighbor.closed) {
					continue;
				}

				var x = pNode.x;
				var y = pNode.y;

				// get the distance between current node and the neighbor
				// and calculate the next g score
				var ng = node.g + ((x - pNode.x === 0 || y - pNode.y === 0) ? 1 : SQRT2);

				// check if the neighbor has not been inspected yet, or
				// can be reached with smaller cost from the current node
				if (!neighbor.opened || ng < neighbor.g) {
					neighbor.g = ng;
					neighbor.h = neighbor.h || weight * heuristic(Math.abs(x - endX), Math.abs(y - endY));
					neighbor.f = neighbor.g + neighbor.h;
					neighbor.parent = node;

					if (!neighbor.opened) {
						openList.push(neighbor);
						neighbor.opened = true;
					} else {
						// the neighbor can be reached with smaller cost.
						// Since its f value has been updated, we have to
						// update its position in the open list
						openList.updateItem(neighbor);
					}
				}
			} // end for each neighbor
		} // end while not open list empty

		// fail to find the path
		return [];
	}
}
