import unit_testing.ai.*;
import unit_testing.assets.*;
import unit_testing.spatial.*;
import unit_testing.tiles.*;
import unit_testing.util.*;

class Tests
{
	static function main()
	{
		var tests = new haxe.unit.TestRunner();

		// Artificial Intelligence
		//tests.add(new PathingTests());

		// Asset Loading
		tests.add(new TmxAssetTests());

		// Core

		// Spatial
		tests.add(new RectRegionTests());
		tests.add(new RTreePartitionTests());
		tests.add(new RegionPartitionTests());

		// Rendering

		// Tiles
		tests.add(new TmxXmlTests());

		// Util
		tests.add(new UtilityTests());
		tests.add(new MoreMathTests());
		//tests.add(new TrieTests());

		tests.run();
	}
}
