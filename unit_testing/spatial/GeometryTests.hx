package unit_testing.spatial;

import titanium_reindeer.spatial.Geometry;
import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.spatial.RectRegion;
import titanium_reindeer.spatial.CircleRegion;

class GeometryTests extends haxe.unit.TestCase
{
	public var rectA:RectRegion;
	public var rectB:RectRegion;
	public var rectC:RectRegion;
	public var rectD:RectRegion;
	public var rectE:RectRegion;
	public var rectF:RectRegion;
	public var rectG:RectRegion;
	public var rectH:RectRegion;

	public var circleA:CircleRegion;
	public var circleB:CircleRegion;
	public var circleC:CircleRegion;
	public var circleD:CircleRegion;
	public var circleE:CircleRegion;

	public var pi:Float = Math.PI;

	public override function setup()
	{
		this.rectA = new RectRegion(100, 100, new Vector2(0, 0));
		this.rectB = new RectRegion(1, 1, new Vector2(32, 23));
		this.rectC = new RectRegion(10, 10, new Vector2(100, 100));
		this.rectD = new RectRegion(60, 50, new Vector2(0, 0));
		this.rectE = new RectRegion(10, 10, new Vector2(-2, -2));
		this.rectF = new RectRegion(4, 4, new Vector2(-20, -18));
		this.rectG = new RectRegion(10, 10, new Vector2(101, 101));
		this.rectH = new RectRegion(5, 5, new Vector2(-2.5, -2.5));

		this.circleA = new CircleRegion(10, new Vector2(0, 0));
		this.circleB = new CircleRegion(4, new Vector2(0, 0));
		this.circleC = new CircleRegion(10, new Vector2(4, 3));
		this.circleD = new CircleRegion(3, new Vector2(20, 14));
		this.circleE = new CircleRegion(20, new Vector2(105, 105));
	}

	/**
	 * Tests for isRectIntersectingRect
	 */
	public function testIsRectIntersectingRect_WhenInside()
	{
		var result = Geometry.isRectIntersectingRect(this.rectA, this.rectB);
		assertTrue(result);
	}
	public function testIsRectIntersectingRect_WhenInsideOnEdge()
	{
		var result = Geometry.isRectIntersectingRect(this.rectA, this.rectC);
		assertTrue(result);
	}
	public function testIsRectIntersectingRect_WhenIntersect()
	{
		var result = Geometry.isRectIntersectingRect(this.rectB, this.rectD);
		assertTrue(result);
	}
	public function testIsRectIntersectingRect_WhenOneOff()
	{
		var result = Geometry.isRectIntersectingRect(this.rectA, this.rectG);
		assertFalse(result);
	}
	public function testIsRectIntersectingRect_WhenNegative()
	{
		var result = Geometry.isRectIntersectingRect(this.rectA, this.rectE);
		assertTrue(result);
	}
	public function testIsRectIntersectingRect_OutsideWhenNegative()
	{
		var result = Geometry.isRectIntersectingRect(this.rectE, this.rectF);
		assertFalse(result);
	}

	/**
	 * Tests for isCircleIntersectingCircle 
	 */
	public function testIsCircleIntersectingCircle_WhenInside()
	{
		var result = Geometry.isCircleIntersectingCircle(this.circleA, this.circleB);
		assertTrue(result);
	}
	public function testIsCircleIntersectingCircle_SomeOverlap()
	{
		var result = Geometry.isCircleIntersectingCircle(this.circleA, this.circleC);
		assertTrue(result);
	}
	public function testIsCircleIntersectingCircle_NoIntersect()
	{
		var result = Geometry.isCircleIntersectingCircle(this.circleA, this.circleD);
		assertFalse(result);
	}

	/**
	 * Tests for isCircleInsideCircle 
	 */
	public function testIsCircleInsideCircle_WhenInside()
	{
		var result = Geometry.isCircleInsideCircle(this.circleB, this.circleA);
		assertTrue(result);
	}
	public function testIsCircleInsideCircle_SomeOverlay()
	{
		var result = Geometry.isCircleInsideCircle(this.circleA, this.circleC);
		assertFalse(result);
	}
	public function testIsCircleInsideCircle_NoIntersect()
	{
		var result = Geometry.isCircleInsideCircle(this.circleA, this.circleD);
		assertFalse(result);
	}

	/**
	 * Tests for isCircleIntersectingRect 
	 */
	public function testIsCircleIntersectingRect_WhenCircleInsideRect()
	{
		var result = Geometry.isCircleIntersectingRect(this.circleB, this.rectH);
		assertTrue(result);
	}
	public function testIsCircleIntersectingRect_WhenRectInsideCircle()
	{
		var result = Geometry.isCircleIntersectingRect(this.circleE, this.rectC);
		assertTrue(result);
	}
	public function testIsCircleIntersectingRect_SomeOverlay()
	{
		var result = Geometry.isCircleIntersectingRect(this.circleA, this.rectA);
		assertTrue(result);
	}
	public function testIsCircleIntersectingRect_NoIntersect()
	{
		var result = Geometry.isCircleIntersectingRect(this.circleB, this.rectG);
		assertFalse(result);
	}

	/**
	 * Tests for getIntersectionOfRectRegions
	 */
	public function testGetIntersectionOfRectRegions_Inside()
	{
		var result = Geometry.getIntersectionOfRectRegions(this.rectA, this.rectB);
		assertEquals(32.0, result.position.x);
		assertEquals(23.0, result.position.y);
		assertEquals(1.0, result.width);
		assertEquals(1.0, result.height);
	}
	public function testGetIntersectionOfRectRegions_SomeOverlap()
	{
		var result = Geometry.getIntersectionOfRectRegions(this.rectD, this.rectE);

		assertEquals(0.0, result.position.x);
		assertEquals(0.0, result.position.y);
		assertEquals(8.0, result.width);
		assertEquals(8.0, result.height);
	}
	public function testGetIntersectionOfRectRegions_NoIntersect()
	{
		var result = Geometry.getIntersectionOfRectRegions(this.rectA, this.rectG);
		assertEquals(null, result);
	}

	/**
	 * Tests for getMidPoint
	 */
	public function testGetMidPoint_Flat()
	{
		var result = Geometry.getMidPoint(new Vector2(0, 0), new Vector2(10, 10));
		assertEquals(5.0, result.x);
		assertEquals(5.0, result.y);
	}
	public function testGetMidPoint_MoreComplex()
	{
		var result = Geometry.getMidPoint(new Vector2(3, 6), new Vector2(12, 10));
		assertEquals(7.5, result.x);
		assertEquals(8.0, result.y);
	}
	public function testGetMidPoint_WithNegatives()
	{
		var result = Geometry.getMidPoint(new Vector2(-1, 6), new Vector2(12, -20));
		assertEquals(5.5, result.x);
		assertEquals(-7.0, result.y);
	}

	/**
	 * Tests for isAngleWithin
	 */
	public function testIsAngleWithin_Within2PIInside()
	{
		assertTrue(Geometry.isAngleWithin(pi, pi + 1, pi / 2));
	}
	public function testIsAngleWithin_Within2PIOutside()
	{
		assertFalse(Geometry.isAngleWithin(pi, pi + 3, pi / 2));
	}
	public function testIsAngleWithin_Over2PIInside()
	{
		assertTrue(Geometry.isAngleWithin(pi * 5, pi + 1, pi / 2));
	}
	public function testIsAngleWithin_Over2PIOutside()
	{
		assertFalse(Geometry.isAngleWithin(pi * 7, pi + 2, pi / 3));
	}
	public function testIsAngleWithin_NegativeInside()
	{
		assertTrue(Geometry.isAngleWithin(-pi, (pi * 3) + 0.2, pi / 6));
	}
	public function testIsAngleWithin_NegativeOutside()
	{
		assertFalse(Geometry.isAngleWithin(-pi, -pi + 3/2, pi / 4));
	}

	/**
	 * Tests for isAngleWithinPair
	 */
	public function testIsAngleWithinPair_Within2PIInside()
	{
		assertTrue(Geometry.isAngleWithinPair(pi, pi + pi / 2, pi + 1));
	}
	public function testIsAngleWithinPair_Within2PIOutside()
	{
		assertFalse(Geometry.isAngleWithinPair(pi, pi + pi / 2, pi + 3));
	}
	public function testIsAngleWithinPair_Over2PIInside()
	{
		assertTrue(Geometry.isAngleWithinPair(pi*5, pi*5 + pi / 2, pi + 1));
	}
	public function testIsAngleWithinPair_Over2PIOutside()
	{
		assertFalse(Geometry.isAngleWithinPair(pi*7, pi*7 + pi/2, pi + 2));
	}
	public function testIsAngleWithinPair_NegativeInside()
	{
		assertTrue(Geometry.isAngleWithinPair(-pi, -pi + pi / 6, (pi*3) + 0.2));
	}
	public function testIsAngleWithinPair_NegativeOutside()
	{
		assertFalse(Geometry.isAngleWithinPair(-pi, -pi + pi / 4, -pi + 3/2));
	}

	/**
	 * Tests for distanceBetweenAngles
	 */
	public function testDistanceBetweenAngles_Simple()
	{
		assertEquals(pi, Geometry.distanceBetweenAngles(pi, 0));
	}
	public function testDistanceBetweenAngles_Around2PI()
	{
		assertEquals(pi/2 + 0.5, Geometry.distanceBetweenAngles(pi * 3/2, 0.5));
	}
	public function testDistanceBetweenAngles_BiggerThan2PI()
	{
		assertEquals(pi - 0.5, Geometry.distanceBetweenAngles(pi * 7, 0.5));
	}
	public function testDistanceBetweenAngles_Negative()
	{
		TestUtils.assertApproxEquals(this, pi*2/3 + 0.5, Geometry.distanceBetweenAngles(-pi * 2/3, 0.5), 11);
	}

	/**
	 * Tests for closestAngle
	 */
	public function testClosestAngle_WhenEmpty()
	{
		assertEquals(pi, Geometry.closestAngle(pi, []));
		assertEquals(pi, Geometry.closestAngle(pi, null));
	}
	public function testClosestAngle_WhenOneElement()
	{
		assertEquals(pi + 0.2, Geometry.closestAngle(pi, [pi + 0.2]));
	}
	public function testClosestAngle_WhenMore()
	{
		assertEquals(pi + 0.2, Geometry.closestAngle(pi, [pi + 0.2, pi + 0.4]));
	}
	public function testClosestAngle_WhenEqual()
	{
		assertEquals(pi + 0.2, Geometry.closestAngle(pi, [pi + 0.2, pi - 0.2]));
	}
	public function testClosestAngle_WhenAround2PI()
	{
		assertEquals(0.5, Geometry.closestAngle(2*pi - 0.2, [0.5, 2*pi - 0.95]));
	}
	public function testClosestAngle_BiggerThan2PI()
	{
		var result = Geometry.closestAngle(pi, [pi*3 + 0.1, pi*5 + 0.2]);
		TestUtils.assertApproxEquals(this, pi + 0.1, result, 11);
	}
	public function testClosestAngle_Negative()
	{
		assertEquals(-pi, Geometry.closestAngle(pi, [-pi, pi + 0.2]));
	}

	/**
	 * Tests of isAngleToTheRight 
	 */
	public function testIsAngleToTheRight_Simple()
	{
		assertTrue(Geometry.isAngleToTheRight(pi, pi + 0.3));
	}
	public function testIsAngleToTheRight_SimpleFalse()
	{
		assertFalse(Geometry.isAngleToTheRight(pi, pi - 0.3));
	}
	public function testIsAngleToTheRight_Around2PI()
	{
		assertTrue(Geometry.isAngleToTheRight(2*pi - 0.2, 0));
	}
	public function testIsAngleToTheRight_Around2PIFalse()
	{
		assertFalse(Geometry.isAngleToTheRight(2*pi - 0.2, -0.5));
	}
	public function testIsAngleToTheRight_Negative()
	{
		assertTrue(Geometry.isAngleToTheRight(-pi, -0.5));
	}
	public function testIsAngleToTheRight_NegativeFalse()
	{
		assertFalse(Geometry.isAngleToTheRight(-pi, pi - 0.5));
	}
}
