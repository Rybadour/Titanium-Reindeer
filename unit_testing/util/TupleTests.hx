package unit_testing.util;

import titanium_reindeer.util.Tuple;

class TupleTests extends haxe.unit.TestCase
{
	private var a:Tuple<Int, String>;
	private var b:Tuple<String, Float>;
	private var c:Tuple3<Int, String, Float>;
	private var d:Tuple3<Int, String, String>;

	public override function setup()
	{
		this.a = new Tuple<Int, String>(1, "A");
		this.b = new Tuple<String, Float>("B", 5.5);

		this.c = new Tuple3<Int, String, Float>(2, "C", 0.5);
		this.d = new Tuple3<Int, String, String>(7, "D", "string");
	}

	public function testTuple()
	{
		// A
		assertEquals(1, this.a.first);
		assertEquals("A", this.a.second);

		// B
		assertEquals("B", this.b.first);
		assertEquals(5.5, this.b.second);
	}

	public function testReferenceUsage()
	{
		// By Ref
		var another = this.a;
		assertEquals(1, another.first);
		assertEquals("A", another.second);

		this.a.second += "bc";
		assertEquals("Abc", this.a.second);
		assertEquals("Abc", another.second);
	}

	public function testTuple3()
	{
		// C
		assertEquals(2, this.c.first);
		assertEquals("C", this.c.second);
		assertEquals(0.5, this.c.third);

		// D
		assertEquals(7, this.d.first);
		assertEquals("D", this.d.second);
		assertEquals("string", this.d.third);
	}
}
