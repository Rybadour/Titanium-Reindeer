package titanium_reindeer.ai.pathing;

interface IPathNodeGraph
{
	public function getAdjacentNodes(node:PathNode):Array<PathNode>;
}
