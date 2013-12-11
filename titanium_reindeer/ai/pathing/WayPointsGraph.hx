package titanium_reindeer.ai.pathing;

class WayPointsGraph implements IRouteProvider
{
	public var nodes(default, null):Array<PathNode>;

	public function new()
	{
		this.nodes = new Array();
	}

	public function addWayPoint(node:PathNode):Void
	{
		this.nodes.push(node);
	}

	public function addConnection(a:PathNode, b:PathNode):Void
	{
	}

	// TODO: Do we like this?
	// Defined algo interface but I like this better
	public function getRoute(start:Vector2, end:Vector2, algo:PathNode -> IPathNodeGraph -> Array<PathNode>)
	{
		var routeNodes:Array<PathNode> = new Array();

		// TODO: Use a specified nearest neighbour algorithm
		for (var node in this.nodes)
		{
		}

		// TODO: Use a specified optimal pathing finding algorithm

		return new Route(start, end, routeNodes);
	}
}
