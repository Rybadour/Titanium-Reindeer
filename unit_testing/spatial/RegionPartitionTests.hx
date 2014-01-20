package unit_testing.spatial;

import titanium_reindeer.core.IUnique;
import titanium_reindeer.spatial.*;
import titanium_reindeer.spatial.RTreePartition;
import titanium_reindeer.spatial.RegionPartition;

class Thing implements IUnique<Int>
{
	private var id:Int;
	public var region:IRegion;

	public function new(id:Int, region:IRegion)
	{
		this.id = id;
		this.region = region;
	}

	public function getKey():Int
	{
		return id;
	}
}

class RegionPartitionTests extends haxe.unit.TestCase
{
	public var regions:RegionPartition<Thing>;

	public var a:Thing;

	public override function setup():Void
	{
		var map:Map<Int, RTreeNode<Int>> = new Map();
		this.regions = new RegionPartition(new RTreePartition(map));
		//this.regions = new RegionPartition(new RTreePartition(map), regionMap);

		this.a = new Thing(13, new RectRegion(10, 10, new Vector2(0, 0)));
		this.regions.add(a, a.region);
	}

	public function testIntersectingCircle()
	{
		var intersecting = this.regions.getIntersectingCircle(new CircleRegion(10, new Vector2(0, 0)));
		assertEquals(13, intersecting[0].getKey());

		var intersecting = this.regions.getIntersectingCircle(new CircleRegion(6, new Vector2(20, 20)));
		assertEquals(0, intersecting.length);
	}

	public function testRemoval()
	{
		this.regions.remove(this.a);

		var intersecting = this.regions.getIntersectingRect(new RectRegion(100, 100, new Vector2(0, 0)));
		assertEquals(0, intersecting.length);

		this.regions.add(this.a, this.a.region);

		var intersecting = this.regions.getIntersectingRect(new RectRegion(100, 100, new Vector2(0, 0)));
		assertEquals(13, intersecting[0].getKey());
	}
}
