package titanium_reindeer;

class Utility
{
	public static function clampInt(n:Int, a:Int, b:Int):Int
	{
		return Math.round(Math.max(a, Math.min(n, b)));
	}

	public static function clampFloat(n:Float, a:Float, b:Float):Float
	{
		return Math.max(a, Math.min(n, b));
	}

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
