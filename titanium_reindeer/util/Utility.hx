package titanium_reindeer.util;

/**
 * A collection of static functions for a variety of simple operations not already specified in the
 * Haxe standard library.
 */
class Utility
{
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
