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
		this.testOriginalState();

		var tempRect = new RectRegion(200, 200, new Vector2(-10, -12));
		this.partition.insert(tempRect, 99);

		var bounds = this.partition.getBoundingRectRegion();
		assertEquals(-10.0, bounds.left);
		assertEquals(-12.0, bounds.top);
		assertEquals(190.0, bounds.right);
		assertEquals(188.0, bounds.bottom);
		this.partition.remove(99);

		this.testOriginalState();
	}

	public function testIntersection()
	{
		var intersecting = this.partition.requestKeysIntersectingRect(aR);
		assertTrue(this.hasAll([a, b, c], intersecting));

		intersecting = this.partition.requestKeysIntersectingRect(bR);
		assertTrue(this.hasAll([a, b], intersecting));

		intersecting = this.partition.requestKeysIntersectingRect(cR);
		assertTrue(this.hasAll([a, c], intersecting));

		intersecting = this.partition.requestKeysIntersectingRect(dR);
		assertTrue(this.hasAll([d], intersecting));

		intersecting = this.partition.requestKeysIntersectingRect(this.partition.getBoundingRectRegion());
		assertTrue(this.hasAll([a, b, c, d], intersecting));
		
		intersecting = this.partition.requestKeysIntersectingRect(new RectRegion(2, 2, new Vector2(78, 100)));
		assertTrue(this.hasAll([a, d], intersecting));
 
 		// Points
		intersecting = this.partition.requestKeysIntersectingPoint(new Vector2(0, 0));
		assertTrue(this.hasAll([a], intersecting));

		intersecting = this.partition.requestKeysIntersectingPoint(new Vector2(11, 11));
		assertTrue(this.hasAll([a, b], intersecting));

		intersecting = this.partition.requestKeysIntersectingPoint(new Vector2(78, 101));
		assertTrue(this.hasAll([d], intersecting));

		intersecting = this.partition.requestKeysIntersectingPoint(new Vector2(5, 5));
		assertTrue(this.hasAll([a, b], intersecting));

		intersecting = this.partition.requestKeysIntersectingPoint(new Vector2(101, 77));
		assertTrue(this.hasAll([], intersecting));
	}

	private function hasAll(asserted:Array<Int>, checked:Array<Int>):Bool
	{
		if (asserted.length != checked.length)
			return false;

		for (value in asserted)
		{
			if ( !Lambda.has(checked, value))
				return false;
		}

		return true;
	}

	private function testOriginalState()
	{
		var bounds = this.partition.getBoundingRectRegion();
		assertEquals(0.0, bounds.left);
		assertEquals(0.0, bounds.top);
		assertEquals(100.0, bounds.right);
		assertEquals(102.0, bounds.bottom);
	}
}
