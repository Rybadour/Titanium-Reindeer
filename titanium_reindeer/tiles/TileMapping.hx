package titanium_reindeer.tiles;

import titanium_reindeer.spatial.Vector2;

class TileMapping
{
	public var tileMap:TileMap;

	public function new(tileMap:TileMap)
	{
		this.tileMap = tileMap;
	}

	/**
	 * Returns true if the given tile at tile coordinate x, y has the given type.
	 */
	public function tileHas(x:Int, y:Int, type:String):Bool
	{
		var index = this.tileMap.getTileIndex(x, y);
		if (index == null)
			return false;

		var types = this._map(index);
		if (types == null)
			return false;

		return this.hasType(types, type);
	}

	/**
	 * Return all tiles matching the specified type.
	 */
	public function getTiles(type:String):Array<Vector2>
	{
		var tiles:Array<Vector2> = new Array();
		var i = 0;
		for (y in 0...this.tileMap.height)
		{
			for (x in 0...this.tileMap.width)
			{
				var types = this._map(this.tileMap.tileIndices[i]);
				if (this.hasType(types, type))
				{
					tiles.push(new Vector2(x, y));
				}
				++i;
			}
		}

		return tiles;
	}

	private function hasType(types:Array<String>, checkType:String):Bool
	{
		if (types != null)
		{
			for (type in types)
			{
				if (type == checkType)
					return true;
			}
		}
		return false;
	}

	private function _map(tileIndex:Int):Array<String>
	{
		return null;
	}
}
