import titanium_reindeer.core.IdProvider;
import titanium_reindeer.components.IWatchedWorldPosition;
import titanium_reindeer.components.RegionGroup;
import titanium_reindeer.components.RegionIntersecter;
import titanium_reindeer.components.CircleRegion;
import titanium_reindeer.components.CircleRegionWatched;
import titanium_reindeer.components.RegionComponent;
import titanium_reindeer.core.RectRegion;
import titanium_reindeer.core.IRegion;

import titanium_reindeer.components.BinPartition;
//import titanium_reindeer.RTreeFastInt;
import titanium_reindeer.Vector2;
import titanium_reindeer.Rect;
import titanium_reindeer.Circle;

class RegionsTests extends haxe.unit.TestCase
{
	private var provider:HasIdProvider;
	private var groupA:RegionGroup;
	private var binPartition:BinPartition;
	//private var rTree:RTreeFastInt;
	private var si:RegionIntersecter;

	private var anchorA:IWatchedWorldPosition;
	private var anchorB:IWatchedWorldPosition;

	private var circleA:RegionComponent<CircleRegionWatched>;
	private var circleB:RegionComponent<CircleRegionWatched>;
	private var circleC:RegionComponent<CircleRegionWatched>;

	public override function setup()
	{
		this.provider = new HasIdProvider();
		this.si = new RegionIntersecter();
		this.binPartition = new BinPartition(10, new Vector2(-50, -50), 100, 100);
		this.groupA = new RegionGroup(this.provider, "testRegion", this.binPartition, this.si);

		//this.rTree = new RTreeFastInt();

		this.anchorA = new Thing();

		this.circleA = new RegionComponent(this.provider, anchorA, new CircleRegionWatched(10, new Vector2(0, 0)));
		groupA.add(circleA.id, circleA.region);

		this.circleB = new RegionComponent(this.provider, anchorA, new CircleRegionWatched(10, new Vector2(0, -12)));
		groupA.add(circleB.id, circleB.region);

		this.circleC = new RegionComponent(this.provider, anchorA, new CircleRegionWatched(10, new Vector2(20, 20)));
		groupA.add(circleC.id, circleC.region);
	}

	public function testRegionGroup()
	{
		assertTrue(groupA.id >= 0);

		// Regions
		var id:Int = this.provider.idProvider.requestId();
		var r:CircleRegion = new CircleRegion(10, new Vector2(0, 0));

		groupA.add(id, r);
		assertEquals(groupA.get(id), r);

		groupA.remove(id);
		assertEquals(groupA.get(id), null);

		// Other region groups
		var bp:BinPartition = new BinPartition(10, new Vector2(0, 0), 10, 10);
		var rg:RegionGroup = new RegionGroup(this.provider, "otherRegion", bp, this.si);

		groupA.addGroup(rg);
		assertEquals(groupA.get(rg.id), rg);
		assertEquals(groupA.getGroup(rg.id), rg);

		groupA.removeGroup(rg);
		assertEquals(groupA.get(rg.id), null);
		assertEquals(groupA.getGroup(rg.id), null);

		groupA.addGroup(rg);
		groupA.remove(rg.id);
		assertEquals(groupA.get(rg.id), null);
		assertEquals(groupA.getGroup(rg.id), null);
	}

	public function testCircleRegion()
	{
		// Point intersections
		var regions:Array<IRegion> = groupA.requestRegionsIntersectingPoint( new Vector2(2, 2) );
		assertEquals(regions.length, 1);

		var regions:Array<IRegion> = groupA.requestRegionsIntersectingPoint( new Vector2(0, -3) );
		assertEquals(regions.length, 2);

		// edge case testing the "roundness" of these circle regions
		var regions:Array<IRegion> = groupA.requestRegionsIntersectingPoint( new Vector2(10, 10) );
		assertEquals(regions.length, 0);

		var regions:Array<IRegion> = groupA.requestRegionsIntersectingPoint( new Vector2(13, 13) );
		assertEquals(regions.length, 1);

		// Region intersections
		var region:IRegion = new RectRegion(20, 20, new Vector2(0, 0));
		var regions:Array<IRegion> = groupA.requestRegionsIntersectingRegion(region);
		assertEquals(regions.length, 2);
	}

	public override function tearDown()
	{
	}
}
