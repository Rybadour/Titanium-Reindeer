package titanium_reindeer.tiles;

import titanium_reindeer.spatial.Vector2;

/**
 * TileMap is a basic implementation that maps the indices stored in an array of length width *
 * height. Tile indices are assumed to be row by row, every width number of elements is a new row.
 */
class TileMap implements ITileMap
{
	/**
	 * A definition of a tile map used to find a tile index.
	 */
	public var definition:TileMapDefinition;

	/**
	 * Flat array of tile indices.
	 */
	public var tileIndices:Array<Int>;

	public function new(definition:TileMapDefinition, tileIndices:Array<Int>)
	{
		this.definition = definition;
		this.tileIndices = tileIndices;
	}

	/**
	 * Returns the tile index at the specified coordinate. The specified width and height is used to
	 * calculate the position in the flat tile array.
	 */
	public function getTileIndex(x:Int, y:Int):Int
	{
		if (x < 0 || x >= this.definition.width || y < 0 || y >= this.definition.height)
			return null;

		var tileIndex = x + y*this.definition.width;
		if (tileIndex >= this.tileIndices.length)
			return null;
		else
			return this.tileIndices[tileIndex];
	}

	/**
	 * Returns a map of tile indices to their corresponding tile positions.
	 */
	public function getAllTilePositions():Map<Int, Vector2>
	{
		var positions:Map<Int, Vector2> = new Map();
		var i = 0;
		for (y in 0...this.definition.height)
		{
			for (x in 0...this.definition.width)
			{
				positions.set(this.tileIndices[i++], new Vector2(x, y));
			}
		}
		return positions;
	}
}
