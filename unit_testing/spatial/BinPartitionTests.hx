import titanium_reindeer.components.BinPartition;
import titanium_reindeer.Vector2;
import titanium_reindeer.core.RectRegion;
import titanium_reindeer.core.Circle;

class BinPartitionTests extends haxe.unit.TestCase
{
	private var bp:BinPartition;

	public override function setup()
	{
		bp = new BinPartition(10, new Vector2(0, 0), 100, 100);

		// first fits snuggly into the first bin
		bp.insert( new RectRegion(6, 6, new Vector2(5, 5)), 1 );

		// second overlaps many bins
		bp.insert( new RectRegion(10, 10, new Vector2(10, 10)), 2 );

		// third is much larger than the bin size
		bp.insert( new RectRegion(60, 60, new Vector2(35, 35)), 3 );
	}

	public function testPointIntersections()
	{
		var ids:Array<Int> = bp.requestValuesIntersectingPoint( new Vector2(3, 3) );
		assertEquals(ids.length, 1);

		ids = bp.requestValuesIntersectingPoint( new Vector2(5, 5) );
		assertEquals(ids.length, 3);

		ids = bp.requestValuesIntersectingPoint( new Vector2(8, 6) );
		assertEquals(ids.length, 2);
	}

	public function testRectIntersections()
	{
		var ids:Array<Int>;
		ids = bp.requestValuesIntersectingRect( new RectRegion(1, 1, new Vector2(3.5, 3.5)) );
		assertEquals(ids.length, 1);

		ids = bp.requestValuesIntersectingRect( new RectRegion(30, 10, new Vector2(24, 14)) );
		assertEquals(ids.length, 2);

		ids = bp.requestValuesIntersectingRect( new RectRegion(10, 10, new Vector2(9, 6)) );
		assertEquals(ids.length, 3);
	}

	// updating old ids

	// deleting

	// Test the automatically expanding coverage area
	// low end

	// high end

	public override function tearDown()
	{
	}
}
