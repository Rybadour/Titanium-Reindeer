package titanium_reindeer.ai.pathing;

interface IPathNodeGraph<T:PathNode>
{
	public function getAdjacentNodes(node:PathNode):Array<T>;
}
