package unit_testing.util;

import titanium_reindeer.util.MoreMath;

class MoreMathTests extends haxe.unit.TestCase
{
	public function testClamp()
	{
		assertEquals(5,   MoreMath.clampInt(0, 10, 5));
		assertEquals(6,   MoreMath.clampInt(10, 2, 6));
		assertEquals(10,  MoreMath.clampInt(10, 10, 10));
		assertEquals(13,  MoreMath.clampInt(13, 13, 13));
		assertEquals(14,  MoreMath.clampInt(13, 14, 14));
		assertEquals(0,   MoreMath.clampInt(-1, 0, 4));
		assertEquals(-7,  MoreMath.clampInt(-1, -123, -7));
		assertEquals(-1,  MoreMath.clampInt(-1, -123, 0));
		assertEquals(-13, MoreMath.clampInt(-13, -123, -1));
	}

	public function testClampFloat()
	{
		assertEquals(5.0,   MoreMath.clampFloat(0, 5, 10));
		assertEquals(6.0,   MoreMath.clampFloat(10, 2, 6));
		assertEquals(10.0,  MoreMath.clampFloat(10, 10, 10));
		assertEquals(13.0,  MoreMath.clampFloat(13, 13, 13));
		assertEquals(13.5,  MoreMath.clampFloat(13, 14, 13.5));

		assertEquals(2.5,   MoreMath.clampFloat(0, 5, 2.5));
		assertEquals(3.5,   MoreMath.clampFloat(7, 0, 3.5));
		assertEquals(-0.5,  MoreMath.clampFloat(-1, 0, -0.5));
		assertEquals(-0.75, MoreMath.clampFloat(-1, -0.5, -0.75));
		assertEquals(0.0,   MoreMath.clampFloat(-100, 100, 0));

		assertEquals(10.0,  MoreMath.clampFloat(10, 100, 0));
		assertEquals(-10.0, MoreMath.clampFloat(-10, -63.23, 52));
		assertEquals(-10.0, MoreMath.clampFloat(-10, -9.99, -10.1));
		assertEquals(-9.0,  MoreMath.clampFloat(-7.5, -9, -10.1));
	}

	public function testRandomNeg()
	{
		for (i in 0...10)
		{
			assertEquals(0, MoreMath.randomWithNeg(0));
		}

		for (i in 0...1000)
		{
			var result = MoreMath.randomWithNeg(10);
			assertTrue(result <= 10 && result >= -10);
		}
	}
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
