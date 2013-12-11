package titanium_reindeer.util;

class MoreMath
{
	// Int
	public static function betweenInt(a:Int, b:Int)
	{
		if (a == b)
			return a;
		return a + Math.round((b - a)/2);
	}

	// Float
	public static function between(a:Float, b:Float)
	{
		if (a == b)
			return a;
		return a + (b - a)/2;
	}
}
