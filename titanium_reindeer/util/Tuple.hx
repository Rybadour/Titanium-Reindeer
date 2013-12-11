package titanium_reindeer.util;

class Tuple<A, B>
{
	public var first:A;
	public var second:B;

	public function new(a:A, b:B)
	{
		this.first = a;
		this.second = b;
	}
}

class Tuple3<A, B, C>
{
	public var first:A;
	public var second:B;
	public var third:C;

	public function new(a:A, b:B, c:C)
	{
		this.first = a;
		this.second = b;
		this.third = c;
	}
}
