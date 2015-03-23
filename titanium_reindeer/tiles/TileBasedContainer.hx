package titanium_reindeer.tiles;

class TileBasedContainer<T>
{
	public var things:Map<Int, Map<Int, T>>;

	public function new()
	{
		this.things = new Map();
	}

	public function get(x:Int, y:Int):T
	{
		if (this.things.exists(x))
		{
			return this.things.get(x).get(y);
		}
		return null;
	}

	public function set(x:Int, y:Int, thing:T):Void
	{
		if ( !this.things.exists(x) )
			this.things.set(x, new Map());

		this.things.get(x).set(y, thing);
	}

	public function remove(x:Int, y:Int):T
	{
		var thing:T = null;
		if (this.things.exists(x))
		{
			thing = this.things.get(x).get(y);
			this.things.get(x).remove(y);
		}
		return thing;
	}

	public function exists(x:Int, y:Int)
	{
		return this.things.exists(x) && this.things.get(x).exists(y);
	}
}
