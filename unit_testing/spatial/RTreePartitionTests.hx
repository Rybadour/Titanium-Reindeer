package unit_testing.spatial;

import titanium_reindeer.spatial.RectRegion;
import titanium_reindeer.spatial.RTreePartition;
import titanium_reindeer.spatial.Vector2;

class RTreePartitionTests extends haxe.unit.TestCase
{
	public var partition:RTreePartition<Int>;
	public var mapping:Map<Int, RTreeNode<Int>>;

	public var a:Int;
	public var aR:RectRegion;

	public var b:Int;
	public var bR:RectRegion;

	public var c:Int;
	public var cR:RectRegion;

	public var d:Int;
	public var dR:RectRegion;

	public override function setup()
	{
		this.mapping = new Map();
		this.partition = new RTreePartition(this.mapping);
		this.partition.maxChildren = 3;

		this.a = 1;
		this.aR = new RectRegion(100, 100, new Vector2(0, 0));

		this.b = 42;
		this.bR = new RectRegion(10, 10, new Vector2(1, 1));

		this.c = 23;
		this.cR = new RectRegion(10, 10, new Vector2(12, 12));

		this.d = 24;
		this.dR = new RectRegion(1, 1, new Vector2(78, 101));

		this.partition.insert(aR, a);
		this.partition.insert(bR, b);
		this.partition.insert(cR, c);
		this.partition.insert(dR, d);
	}

	public function testBounds()
	{
		var bounds = this.partition.getBoundingRectRegion();
		assertEquals(0.0, bounds.left);
		assertEquals(0.0, bounds.top);
		assertEquals(100.0, bounds.right);
		assertEquals(102.0, bounds.bottom);
	}
}
