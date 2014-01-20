package unit_testing.spatial;

import titanium_reindeer.spatial.RectRegion;
import titanium_reindeer.spatial.Vector2;

class RectRegionTests extends haxe.unit.TestCase
{
	public var a:RectRegion;
	public var b:RectRegion;
	public var c:RectRegion;

	public override function setup()
	{
		this.a = new RectRegion(100, 100, new Vector2(0, 0));
		this.b = new RectRegion(1, 1, new Vector2(32, 23));
		this.c = new RectRegion(10, 10, new Vector2(100, 100));
	}

	public function testExpandToCover()
	{
		var result = RectRegion.expandToCover(this.a, this.b);
		assertEquals(0.0, result.left);
		assertEquals(0.0, result.top);
		assertEquals(100.0, result.right);
		assertEquals(100.0, result.bottom);
	}
}
