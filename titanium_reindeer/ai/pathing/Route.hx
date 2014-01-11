package titanium_reindeer.ai.pathing;

/**
 * An ordered list of PathNode to get from a position to a destination
 * The first node is the closest node to the given start position. 
 * The last node is the closest node to the destination position
 */
class Route<N:PathNode>
{
	public var nodes(default, null):Array<N>;

	public var start(get, null):PathNode;
	function get_start()
	{
		if (nodes.length > 0)
			return nodes[0];
		else
			return null;
	}
	public var end(get, null):PathNode;
	function get_end()
	{
		if (nodes.length > 0)
			return nodes[nodes.length-1];
		else
			return null;
	}

	private var targetNodeIndex:Int;

	public function new(nodes:Array<N>)
	{
		this.nodes = nodes;
	}
}
