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

	public function iterateTileRegion(cb:T -> Void, x:Int, y:Int, ?width:Int = 1, ?height:Int = 1)
	{
		for (i in x...x+width)
		{
			if (this.things.exists(i))
			{
				for (j in y...y+height)
				{
					cb(this.things.get(i).get(j));
				}
			}
			else
			{
				cb(null);
			}
		}
	}

	public function set(thing:T, x:Int, y:Int, ?width:Int = 1, ?height:Int = 1):Void
	{
		width = Math.floor(Math.abs(width));
		height = Math.floor(Math.abs(height));
		for (i in x...x+width)
		{
			if ( !this.things.exists(i) )
				this.things.set(i, new Map());

			for (j in y...y+height)
			{
				this.things.get(i).set(j, thing);
			}
		}
	}

	public function remove(x:Int, y:Int, ?width:Int = 1, ?height:Int = 1):Void
	{
		for (i in x...x+width)
		{
			if (this.things.exists(i))
			{
				for (j in y...y+height)
				{
					this.things.get(i).remove(j);
				}
			}
		}
	}

	public function exists(x:Int, y:Int):Bool
	{
		return this.things.exists(x) && this.things.get(x).exists(y);
	}

	public function anyExists(x:Int, y:Int, width:Int, height:Int):Bool
	{
		for (i in x...x+width)
		{
			if ( !this.things.exists(i) )
				continue;

			for (j in y...y+height)
			{
				if (this.things.get(i).exists(j))
					return true;
			}
		}

		return false;
	}
}
