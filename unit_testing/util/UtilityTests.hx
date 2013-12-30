package unit_testing.util;

import titanium_reindeer.util.Utility;

class UtilityTests extends haxe.unit.TestCase
{
	public function testClamp()
	{
		assertEquals(5,   Utility.clampInt(0, 10, 5));
		assertEquals(6,   Utility.clampInt(10, 2, 6));
		assertEquals(10,  Utility.clampInt(10, 10, 10));
		assertEquals(13,  Utility.clampInt(13, 13, 13));
		assertEquals(14,  Utility.clampInt(13, 14, 14));
		assertEquals(0,   Utility.clampInt(-1, 0, 4));
		assertEquals(-7,  Utility.clampInt(-1, -123, -7));
		assertEquals(-1,  Utility.clampInt(-1, -123, 0));
		assertEquals(-13, Utility.clampInt(-13, -123, -1));
	}

	public function testClampFloat()
	{
		assertEquals(5.0,   Utility.clampFloat(0, 5, 10));
		assertEquals(6.0,   Utility.clampFloat(10, 2, 6));
		assertEquals(10.0,  Utility.clampFloat(10, 10, 10));
		assertEquals(13.0,  Utility.clampFloat(13, 13, 13));
		assertEquals(13.5,  Utility.clampFloat(13, 14, 13.5));

		assertEquals(2.5,   Utility.clampFloat(0, 5, 2.5));
		assertEquals(3.5,   Utility.clampFloat(7, 0, 3.5));
		assertEquals(-0.5,  Utility.clampFloat(-1, 0, -0.5));
		assertEquals(-0.75, Utility.clampFloat(-1, -0.5, -0.75));
		assertEquals(0.0,   Utility.clampFloat(-100, 100, 0));

		assertEquals(10.0,  Utility.clampFloat(10, 100, 0));
		assertEquals(-10.0, Utility.clampFloat(-10, -63.23, 52));
		assertEquals(-10.0, Utility.clampFloat(-10, -9.99, -10.1));
		assertEquals(-9.0,  Utility.clampFloat(-7.5, -9, -10.1));
	}

	public function testRandomNeg()
	{
		for (i in 0...10)
		{
			assertEquals(0, Utility.randomWithNeg(0));
		}

		for (i in 0...1000)
		{
			var result = Utility.randomWithNeg(10);
			assertTrue(result <= 10 && result >= -10);
		}
	}
}
