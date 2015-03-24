package titanium_reindeer.util;

/**
 * A collection of static functions for simple integer and float value manipulation.
 */
class MoreMath
{
	/**
	 * Returns n contained to with a and b. A value outside of the a - b range yields which ever is
	 * closest of a or b.
	 */
	public static function clampInt(n:Int, a:Int, b:Int):Int
	{
		// First ensure a and b are lowest and highest respectively
		if (a > b)
		{
			var s = a;
			a = b;
			b = s;
		}
		return Math.round(Math.max(a, Math.min(n, b)));
	}

	/**
	 * See above (but for float).
	 */
	public static function clampFloat(n:Float, a:Float, b:Float):Float
	{
		// First ensure a and b are lowest and highest respectively
		if (a > b)
		{
			var s = a;
			a = b;
			b = s;
		}
		return Math.max(a, Math.min(n, b));
	}

	/**
	 * Returns a random integer within -x and x
	 */
	public static function randomWithNeg(x:Int):Int
	{
		return Std.random(x*2) - x;
	}

	/**
	 * Returns the sign of the number, either -1 for negative or 1 for positive.
	 */
	public static function sign(x:Float):Float
	{
		return ( x < 0 ? -1 : 1 );
	}

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

	public static function floatToStringPrecision(n:Float, prec:Int)
	{
		n = Math.round(n * Math.pow(10, prec));
		var str = ''+n;
		var len = str.length;
		if (len <= prec)
		{
			while (len < prec)
			{
				str = '0'+str;
				len++;
			}
			return '0.'+str;
		}
		else
		{
			return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
		}
	}
}
