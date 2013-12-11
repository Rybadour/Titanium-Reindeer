package titanium_reindeer.ai.pathing;

interface IRoutingAlgorithm
{
	public function getRoute(startNode:PathNode, nodeLookup:IPathNodeGraph):Array<PathNode>;
}
