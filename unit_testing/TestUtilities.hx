package unit_testing;

class TestUtilities
{
	public static function floatApproxEquals(expected:Float, actual:Float, epsilon:Float = 0.0001)
	{
		return (expected - epsilon <= actual) && (actual <= expected + epsilon);
	}
}
