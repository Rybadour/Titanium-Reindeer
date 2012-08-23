import titanium_reindeer.BinPartition;
import titanium_reindeer.Vector2;
import titanium_reindeer.Rect;
import titanium_reindeer.Circle;

class BinPartitionTests extends haxe.unit.TestCase
{
	private var bp:BinPartition;

	public override function setup()
	{
		bp = new BinPartition(10, new Vector2(0, 0), 100, 100);

		// first fits snuggly into the first bin
		bp.insert( new Rect(2, 2, 6, 6), 1 );

		// second overlaps many bins
		bp.insert( new Rect(5, 5, 10, 10), 2 );

		// third is much larger than the bin size
		bp.insert( new Rect(5, 5, 60, 60), 3 );
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
		ids = bp.requestValuesIntersectingRect( new Rect(3, 3, 1, 1) );
		assertEquals(ids.length, 1);

		ids = bp.requestValuesIntersectingRect( new Rect(9, 9, 30, 10) );
		assertEquals(ids.length, 2);

		ids = bp.requestValuesIntersectingRect( new Rect(4, 1, 10, 10) );
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
