package titanium_reindeer.nape;

import nape.geom.Vec2;

abstract Vector2ToVec2(Vector2) {
	inline function new(v:Vector2)
		this = v;

	@:from static public inline function fromVec2ToVector2(v:Vector2)
	{
		return new Vector2ToVec2(new Vector2(v.x, v.y));
	}

	@:to static public function toVec2(v:Vector2)
	{
		return new Vec2(v.x, v.y);
	}
}
