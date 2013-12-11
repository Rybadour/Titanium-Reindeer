package titanium_reindeer.nape;

import nape.space.Space;
import nape.space.Broadphase;

class NapeSpace
{
	public var space(default, null):Space;

	public function new(?gravity:Vector2ToVec2 = null, ?broadPhase:Broadphase = null)
	{
		if (broadPhase == null)
			broadPhase = Broadphase.DYNAMIC_AABB_TREE;
		this.space = new Space(gravity, broadPhase);
	}

	public function addBody(b:NapeBody):Void
	{
		this.space.bodies.push(b.nBody);
	}

	public function update(msTimeStep:Int):Void
	{
		this.space.step(msTimeStep/1000);
	}
}
