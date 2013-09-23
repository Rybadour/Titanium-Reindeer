package util;

class MoreMath
{
	// Int
	public static function betweenInt(a:Int, b:Int)
	{
		return a + Math.round((b - a)/2);
	}


	// Float
	public static function between(a:Float, b:Float)
	{
		return a + (b - a)/2;
	}
}
