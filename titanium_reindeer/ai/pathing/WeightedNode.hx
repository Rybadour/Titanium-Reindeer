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
		this.closed = true;
	}

	public static function sort<N:PathNode>(a:WeightedNode<N>, b:WeightedNode<N>):Int
	{
		var f:Float = a.f - b.f;
		if (f == 0) return 0;
		return (f < 0) ? -1 : 1;
	}
}
