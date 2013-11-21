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
		assertEquals(this.a.first, 1);
		assertEquals(this.a.second, "A");

		// B
		assertEquals(this.b.first, "B");
		assertEquals(this.b.second, 5.5);
	}

	public function testReferenceUsage()
	{
		// By Ref
		var another = this.a;
		assertEquals(another.first, 1);
		assertEquals(another.second, "A");

		this.a.second += "bc";
		assertEquals(this.a.second, "Abc");
		assertEquals(another.second, "Abc");
	}

	public function testTuple3()
	{
		// C
		assertEquals(this.c.first, 2);
		assertEquals(this.c.second, "C");
		assertEquals(this.c.third, 0.5);

		// D
		assertEquals(this.d.first, 7);
		assertEquals(this.d.second, "D");
		assertEquals(this.d.third, "string");
	}
}
