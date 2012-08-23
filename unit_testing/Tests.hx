class Tests
{
	static function main()
	{
		var tests = new haxe.unit.TestRunner();

		// Partitions
		//tests.add( new RTreeTests() );
		tests.add( new BinPartitionTests() );

		// Components
		tests.add( new RegionsTests() );

		tests.run();
	}
}
