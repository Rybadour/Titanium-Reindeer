import titanium_reindeer.core.IProvidesIds;
import titanium_reindeer.components.IWatchedWorldPosition;
import titanium_reindeer.components.RegionGroup;
import titanium_reindeer.components.ShapeIntersecter;
import titanium_reindeer.components.CircleRegion;
import titanium_reindeer.components.IRegion;
import titanium_reindeer.components.IShape;

import titanium_reindeer.BinPartition;
//import titanium_reindeer.RTreeFastInt;
import titanium_reindeer.Vector2;
import titanium_reindeer.Rect;
import titanium_reindeer.Circle;

class RegionsTests extends haxe.unit.TestCase
{
	private var provider:IProvidesIds;
	private var groupA:RegionGroup;
	private var binPartition:BinPartition;
	//private var rTree:RTreeFastInt;
	private var si:ShapeIntersecter;

	private var anchorA:IWatchedWorldPosition;
	private var anchorB:IWatchedWorldPosition;

	private var circleA:CircleRegion;
	private var circleB:CircleRegion;
	private var circleC:CircleRegion;

	public override function setup()
	{
		this.provider = new IdProvider();
		this.si = new ShapeIntersecter();
		this.binPartition = new BinPartition(10, new Vector2(-50, -50), 100, 100);
		this.groupA = new RegionGroup(this.provider, "testRegion", binPartition, si);

		//this.rTree = new RTreeFastInt();

		this.anchorA = new Thing();

		this.circleA = new CircleRegion(this.provider, anchorA, 10);
		groupA.add(circleA);

		this.circleB = new CircleRegion(this.provider, anchorA, 10);
		this.circleB.offset = new Vector2(0, -12);
		groupA.add(circleB);

		this.circleC = new CircleRegion(this.provider, anchorA, 10);
		this.circleC.offset = new Vector2(20, 20);
		groupA.add(circleC);
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

		// Shape intersections
		var shape:IShape = new Rect(0, 0, 20, 20);
		var regions:Array<IRegion> = groupA.requestRegionsIntersectingShape(shape);
		assertEquals(regions.length, 2);
	}

	public override function tearDown()
	{
	}
}
