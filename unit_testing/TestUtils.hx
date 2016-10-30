package unit_testing;

class TestUtils {

	/**
	 * Asserts that the expected value is approximately eqaul to the actual value based on a given
	 * precision.
	 */
	public static function assertApproxEquals(test:haxe.unit.TestCase, expected:Float, actual:Float, precision:Int):Void
	{
		test.assertEquals(TestUtils.round(expected, precision), TestUtils.round(actual, precision));
	}

	private static function round(value:Float, precision:Int):Float
	{
		value *= Math.pow(10, precision);
		return Math.round(value) / Math.pow(10, precision);
	}

}
