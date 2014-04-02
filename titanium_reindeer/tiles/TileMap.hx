package titanium_reindeer.tiles;

class TileMap implements ITileMap
{
	public var tileIndices:Array<Int>;
	public var width:Int;
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
		if (x < 0 OR x >= this.width OR y < 0 OR y >= this.height)
		{
			return null;
		}
		return this.tileIndices[x + y*this.width];
	}
}
