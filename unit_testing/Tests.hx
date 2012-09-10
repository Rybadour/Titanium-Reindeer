class Tests
{
	static function main()
	{
		var tests = new haxe.unit.TestRunner();

		// Core
		tests.add( new IdProviderTests() );
		tests.add( new UpdaterTests() );
		tests.add( new SceneTests() );

		// Partitions
		//tests.add( new RTreeTests() );
		tests.add( new BinPartitionTests() );

		// Components
		tests.add( new RegionsTests() );

		tests.run();
	}
}
