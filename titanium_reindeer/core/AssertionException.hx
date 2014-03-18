package titanium_reindeer.core;

class AssertionException
{
	public var expected:String;
	public var actual:String;

	public function new(expected:String, actual:String)
	{
		this.expected = expected;
		this.actual = actual;
	}

	public function toString():String
	{
		return "Expected value '" + this.expected + "' but was actually '" + this.actual + "'.";
	}

	public static function assert(expected:String, actual:String)
	{
		if (expected != actual)
		{
			throw new AssertionException(expected, actual);
		}
	}
}
