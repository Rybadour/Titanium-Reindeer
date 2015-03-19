package titanium_reindeer.ai.pathing;

import titanium_reindeer.spatial.Vector2;

class RoutingAlgorithms
{
	public static function aStar<N:PathNode>(start:N, end:N, graph:IPathNodeGraph<N>, ?heuristic:Vector2 -> Vector2 -> Float):Array<N>
	{
		var openList:Array<WeightedNode<N>> = new Array();
		if (heuristic == null)
		{
			// Default to manhanttan heuristic
			heuristic = function (a, b) {
				var dx = Math.abs(b.x - a.x);
				var dy = Math.abs(b.y - a.y);
				return dx + dy;
			};
		}

		var SQRT2:Float = Math.sqrt(2);

		var nodeMap:Map<String, WeightedNode<N>> = new Map();
		var getWeighted:N -> WeightedNode<N> = function (node:N) {
			var key:String = node.x+","+node.y;
			if (!nodeMap.exists(key))
				nodeMap.set(key, new WeightedNode<N>(node));
			return nodeMap.get(key);
		};

		var applyHeuristic:WeightedNode<N> -> Void = function (node) {
			if (node.h == null)
				node.h = heuristic(node.node, end);
		};

		// push the start node into the open list
		var startNode:WeightedNode<N> = getWeighted(start);
		openList.push(startNode);
		startNode.open();
		applyHeuristic(startNode);

		// while the open list is not empty
		while (openList.length > 0)
		{
			// pop the position of node which has the minimum `f` value.
			var wNode = openList.shift();
			wNode.close();

			// if reached the end position, construct the path and return it
			// Use the getWeighted() mapping to do an accurate equals check
			if (wNode == getWeighted(end))
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

				// Find the cost of the neighbor node from the start
				var ng = wNode.g + pNode.weight;

				// check if the neighbor has not been inspected yet, or
				// can be reached with smaller cost from the current node
				if (!neighbor.opened || ng < neighbor.g) {
					neighbor.g = ng;
					applyHeuristic(neighbor);
					neighbor.f = neighbor.g + neighbor.h;
					neighbor.parent = wNode;

					if (!neighbor.opened)
					{
						openList.push(neighbor);
						neighbor.open();
					}
					openList.sort(WeightedNode.sort);
				}
			} // end for each neighbor
		} // end while not open list empty

		// fail to find the path
		return [];
	}
}
