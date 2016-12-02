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

	public static function randomBetween(a:Int, b:Int):Int
	{
		if (a > b)
		{
			var swap = b;
			b = a;
			a = swap;
		}

		return a + Std.random(b - a);
	}

	public static function randomBetweenf(a:Float, b:Float):Float
	{
		if (a > b)
		{
			var swap = b;
			b = a;
			a = swap;
		}

		return a + Math.random() * (b - a);
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

	public static function floatToStringPrecision(n:Float, prec:Int):String
	{
		var up = Math.pow(10, -prec);
		var down = Math.pow(10, prec);
		var str = "" + Math.round(n * up) * down;
		if (str.indexOf(".") != -1)
		{
			var parts = str.split(".");
			if (prec > 0)
				str = parts[0];
			else
			{
				if (parts[1].length > -prec)
					parts[1] = parts[1].substr(0, -prec);
				str = parts.join(".");
			}
		}
		return str;
	}

    public static inline function isEven(n:Float)
    {
        return n % 2 == 0;
    }

    public static inline function isOdd(n:Float)
    {
        return Math.abs(n % 2) == 1;
    }

	public static inline function unsignedModulo(a:Float, b:Float):Float
	{
		return a - Math.floor(a/b) * b;
	}
}
