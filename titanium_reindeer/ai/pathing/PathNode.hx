package titanium_reindeer.ai.pathing;

import titanium_reindeer.spatial.Vector2;

class PathNode extends Vector2
{
	public var weight:Float;

	public function new(x:Float, y:Float, ?weight:Float = 1)
	{
		super(x, y);

		this.weight = weight;
	}
}
