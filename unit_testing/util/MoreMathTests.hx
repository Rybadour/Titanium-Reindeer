package unit_testing.util;

import titanium_reindeer.util.MoreMath;

class MoreMathTests extends haxe.unit.TestCase
{
	public function testBetweenInt()
	{
		assertEquals(5,  MoreMath.betweenInt(0, 10));
		assertEquals(6,  MoreMath.betweenInt(10, 2));
		assertEquals(10, MoreMath.betweenInt(10, 10));
		assertEquals(13, MoreMath.betweenInt(13, 13));
		assertEquals(14, MoreMath.betweenInt(13, 14));
	}

	public function testBetweenFloat()
	{
		assertEquals(5.0,   MoreMath.between(0, 10));
		assertEquals(6.0,   MoreMath.between(10, 2));
		assertEquals(10.0,  MoreMath.between(10, 10));
		assertEquals(13.0,  MoreMath.between(13, 13));
		assertEquals(13.5,  MoreMath.between(13, 14));

		assertEquals(2.5,   MoreMath.between(0, 5));
		assertEquals(3.5,   MoreMath.between(7, 0));
		assertEquals(-0.5,  MoreMath.between(-1, 0));
		assertEquals(-0.75, MoreMath.between(-1, -0.5));
		assertEquals(0.0,   MoreMath.between(-100, 100));
	}
}
