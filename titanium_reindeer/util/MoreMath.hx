package titanium_reindeer.util;

/**
 * A collection of static functions for simple integer and float value manipulation.
 */
class MoreMath
{
	/**
	 * Returns the integer value at the center of a and b.
	 * An odd difference rounds up.
	 */
	public static function betweenInt(a:Int, b:Int)
	{
		if (a == b)
			return a;
		return a + Math.round((b - a)/2);
	}

	/**
	 * Returns the float value at the center of a and b.
	 */
	public static function between(a:Float, b:Float)
	{
		if (a == b)
			return a;
		return a + (b - a)/2;
	}
}
