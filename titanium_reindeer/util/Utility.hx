package titanium_reindeer.util;

class Utility
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
	 * Detects the availability of web workers in the browser.
	 * Returns true if the feature is available to use.
	 */
	public static function browserHasWebWorkers():Bool
	{
		var r:Bool = false;
		untyped
		{
			__js__('r = !!Window.Worker');
		}
		return r;
	}
}
