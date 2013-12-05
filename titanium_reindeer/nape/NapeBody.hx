package titanium_reindeer.nape;

import nape.phys.Body;
import nape.phys.BodyType;

class NapeBody
{
	public var nBody(default, null):Body;

	public var position(get, set):Vector2;
	function get_position() { return Vec2ToVector2.toVector2(this.nBody.position); }
	function set_position(value) { this.nBody.position = Vector2ToVec2.toVec2(value); return value; }

	public function new(?type:BodyType = null, ?position:Vector2ToVec2 = null)
	{
		if (type == null)
			type = BodyType.DYNAMIC;
		this.nBody = new Body(type, position);
		this.nBody.mass = 1;
		this.nBody.inertia = 1;
	}
}
