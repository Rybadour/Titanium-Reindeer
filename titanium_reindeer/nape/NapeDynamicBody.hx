package titanium_reindeer.nape;

import nape.phys.BodyType;

class NapeDynamicBody extends NapeBody
{
	public var velocity(get, set):Vector2;
	function get_velocity() { return Vec2ToVector2.toVector2(this.nBody.velocity); }
	function set_velocity(value) { this.nBody.velocity = Vector2ToVec2.toVec2(value); return value; }

	public var direction(get, set):Float;
	function get_direction() { return this.nBody.rotation; }
	function set_direction(value) { return this.nBody.rotation = value; }

	public function new(?position:Vector2ToVec2 = null)
	{
		super(BodyType.DYNAMIC, position);
	}
}
