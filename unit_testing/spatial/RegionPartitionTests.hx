package unit_testing.spatial;

import titanium_reindeer.spatial.*;
import titanium_reindeer.spatial.RTreePartition;
import titanium_reindeer.spatial.RegionPartition;

class Thing implements IPartitionable<Int>
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

	public override function setup():Void
	{
		var map:Map<Int, RTreeNode<Int>> = new Map();
		this.regions = new RegionPartition(new RTreePartition(map));
		//this.regions = new RegionPartition(new RTreePartition(map), regionMap);

		var a = new Thing(0, new RectRegion(10, 10, new Vector2(0, 0)));
		this.regions.add(a, a.region);
	}

	public function testIntersectingCircle()
	{
		var intersecting = this.regions.getIntersectingCircle(new CircleRegion(10, new Vector2(0, 0)));
		assertEquals(0, intersecting[0].getKey());
	}
}
