package unit_testing.util;

import titanium_reindeer.util.MoreMath;

class MoreMathTests extends haxe.unit.TestCase
{
	public function testBetweenInt()
	{
		assertEquals(MoreMath.betweenInt(0, 10), 5);
		assertEquals(MoreMath.betweenInt(10, 2), 6);
		assertEquals(MoreMath.betweenInt(10, 10), 10);
		assertEquals(MoreMath.betweenInt(13, 13), 13);
		assertEquals(MoreMath.betweenInt(13, 14), 14);
	}

	public function testBetweenFloat()
	{
		assertEquals(MoreMath.between(0, 10), 5);
		assertEquals(MoreMath.between(10, 2), 6);
		assertEquals(MoreMath.between(10, 10), 10);
		assertEquals(MoreMath.between(13, 13), 13);
		assertEquals(MoreMath.between(13, 14), 13.5);

		assertEquals(MoreMath.between(0, 5), 2.5);
		assertEquals(MoreMath.between(7, 0), 3.5);
		assertEquals(MoreMath.between(-1, 0), -0.5);
		assertEquals(MoreMath.between(-1, -0.5), -0.75);
		assertEquals(MoreMath.between(-100, 100), 0);
	}
}
