package titanium_reindeer.nape;

import nape.geom.Vec2;

abstract Vec2ToVector2(Vec2) {
	inline function new(v:Vec2)
		this = v;

	@:from static public function fromVector2ToVec2(v:Vector2)
	{
		return new Vec2ToVector2(new Vec2(v.x, v.y));
	}

	@:to static public function toVector2(v:Vec2)
	{
		return new Vector2(v.x, v.y);
	}
}
