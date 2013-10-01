package titanium_reindeer.ai.pathing;

class WeightedNode<N:PathNode>
{
	public var node:N;
	public var opened:Bool;
	public var closed:Bool;

	public var f:Float;
	public var g:Float;
	public var h:Float;

	public var parent:WeightedNode<N>;

	public function new(node:N)
	{
		this.opened = false;
		this.closed = false;
		this.node = node;

		this.f = 0;
		this.g = 0;
		this.h = null;
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

	public static function sort<N:PathNode>(a:WeightedNode<N>, b:WeightedNode<N>):Int
	{
		var f:Float = a.f - b.f;
		if (f == 0) return 0;
		return (f < 0) ? -1 : 1;
	}
}

class RoutingAlgorithms
{
	public static function aStar<N:PathNode>(start:N, end:N, graph:IPathNodeGraph<N>, ?heuristic:Float -> Float -> Float):Array<N>
	{
		// TODO: Parameter or class member or something sometime
		var weight = 1;

		var openList:Array<WeightedNode<N>> = new Array();
		if (heuristic == null)
		{
			heuristic = function (dx, dy) { return dx + dy; };
		}

		var SQRT2:Float = Math.sqrt(2);

		var nodeMap:Map<String, WeightedNode<N>> = new Map();
		var getWeighted:N -> WeightedNode<N> = function (node:N) {
			var key:String = node.x+","+node.y;
			if (!nodeMap.exists(key))
				nodeMap.set(key, new WeightedNode<N>(node));
			return nodeMap.get(key);
		};

		// push the start node into the open list
		var startNode:WeightedNode<N> = getWeighted(start);
		openList.push(startNode);
		startNode.open();

		// while the open list is not empty
		while (openList.length > 0)
		{
			// pop the position of node which has the minimum `f` value.
			var wNode = openList.pop();
			wNode.close();

			// if reached the end position, construct the path and return it
			if (wNode.node == end)
			{
				var path:Array<N> = new Array();
				var n = wNode;
				while (n.parent != null)
				{
					path.push(n.node);
					n = n.parent;
				}
				path.push(n.node);
				path.reverse();
				return path;
			}

			// get neigbours of the current node
			var neighbors:Array<N> = graph.getAdjacentNodes(wNode.node);
			for (pNode in neighbors)
			{
				var neighbor = getWeighted(pNode);
				if (neighbor.closed)
					continue;

				var x = neighbor.node.x;
				var y = neighbor.node.y;

				// get the distance between current node and the neighbor
				// and calculate the next g score
				var ng = wNode.g + ((x - wNode.node.x == 0 || y - wNode.node.y == 0) ? 1 : SQRT2);

				// check if the neighbor has not been inspected yet, or
				// can be reached with smaller cost from the current node
				if (!neighbor.opened || ng < neighbor.g) {
					neighbor.g = ng;
					if (neighbor.h == null)
						neighbor.h = weight * heuristic(Math.abs(x - end.x), Math.abs(y - end.y));
					neighbor.f = neighbor.g + neighbor.h;
					neighbor.parent = wNode;

					if (!neighbor.opened)
					{
						openList.push(neighbor);
						neighbor.open();
					}
					else
					{
						// the neighbor can be reached with smaller cost.
						// Since its f value has been updated, we have to
						// update its position in the open list
						openList.sort(WeightedNode.sort);
					}
				}
			} // end for each neighbor
		} // end while not open list empty

		// fail to find the path
		return [];
	}
}
