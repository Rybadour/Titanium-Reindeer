package titanium_reindeer.tiles;

/**
 * TileMap is a basic implementation that maps the indices stored in an array of length width *
 * height. Tile indices are assumed to be row by row, every width number of elements is a new row.
 */
class TileMap implements ITileMap
{
	/**
	 * Flat array of tile indices.
	 */
	public var tileIndices:Array<Int>;

	/**
	 * The size of each row in tiles.
	 */
	public var width:Int;

	/**
	 * The size of each column in tiles.
	 */
	public var height:Int;

	public function new(tileIndices:Array<Int>, width:Int, height:Int)
	{
		this.tileIndices = tileIndices;
		this.width = width;
		this.height = height;
	}

	/**
	 * Returns the tile index at the specified coordinate. The specified width and height is used to
	 * calculate the position in the flat tile array.
	 */
	public function getTileIndex(x:Int, y:Int):Int
	{
		if (x < 0 || x >= this.width || y < 0 || y >= this.height)
			return null;

		var tileIndex = x + y*this.width;
		if (tileIndex >= this.tileIndices.length)
			return null;
		else
			return this.tileIndices[tileIndex];
	}
}
