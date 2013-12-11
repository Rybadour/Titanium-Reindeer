import unit_testing.util.MoreMathTests;
import unit_testing.util.TupleTests;

class Tests
{
	static function main()
	{
		var tests = new haxe.unit.TestRunner();

		// Core

		// Spatial

		// Rendering

		// Util
		tests.add(new MoreMathTests());
		tests.add(new TupleTests());

		tests.run();
	}
}
