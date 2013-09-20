package titanium_reindeer.ai.pathing;

/**
 * An ordered list of PathNode to get from a position to a destination
 * The first node is the closest node to the given start position. 
 * The last node is the closest node to the destination position
 */
class Route
{
	public var start(default, null):Vector2;
	public var end(default, null):Vector2;

	public var nodes(default, null):Array<PathNode>;

	private var targetNodeIndex:Int;

	public function new(start:Vector2, end:Vector2, nodes:Array<PathNode>)
	{
		this.start = start;
		this.end = start;
		this.nodes = nodes;

		this.targetNodeIndex = 0;
	}

	public function targetNode():PathNode
	{
		return this.nodes[this.targetNodeIndex];
	}

	public function nextNode():PathNode
	{
		if (this.nodes.length == this.targetNodeIndex+1)
			return null;

		return this.nodes[this.targetNodeIndex+1];
	}
}
