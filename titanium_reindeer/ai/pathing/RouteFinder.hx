package titanium_reindeer.ai.pathing;

typedef RoutingAlgo<N:PathNode> = N -> N -> IPathNodeGraph<N> -> (Float -> Float -> Float) -> Array<N>;

class RouteFinder<N:PathNode>
{
	public var graph:IPathNodeGraph<N>;
	public var routingAlgorithm:RoutingAlgo<N>;
	public var heuristic:Float -> Float -> Float;

	public function new(graph:IPathNodeGraph<N>, ?routingAlgorithm:RoutingAlgo<N>, ?heuristic:Float -> Float -> Float)
	{
		this.graph = graph;
		this.routingAlgorithm = routingAlgorithm;
		this.heuristic = heuristic;

		if (this.routingAlgorithm == null)
			this.routingAlgorithm = RoutingAlgorithms.aStar;
	}

	public function findRoute(start:N, end:N):Array<N>
   	{
		return this.routingAlgorithm(start, end, this.graph, this.heuristic);
	}
}
