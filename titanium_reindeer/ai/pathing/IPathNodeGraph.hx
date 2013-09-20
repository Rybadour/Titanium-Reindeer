package titanium_reindeer.ai.pathing;

interface IPathNodeGraph
{
	public function getConnectedNodes(node:PathNode):Array<PathNode>;
}
