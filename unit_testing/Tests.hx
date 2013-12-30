import unit_testing.util.*;

class Tests
{
	static function main()
	{
		var tests = new haxe.unit.TestRunner();

		// Core

		// Spatial

		// Rendering

		// Util
		tests.add(new UtilityTests());
		tests.add(new MoreMathTests());
		tests.add(new TrieTests());
		tests.add(new TupleTests());

		tests.run();
	}
}
