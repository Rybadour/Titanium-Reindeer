package titanium_reindeer.tiles;

/**
 * A tile map is intended to be a class that encapsulates the mapping from tile coords to a given
 * tile index. The tile index is an identifier of a particular tile in a tile set.
 */
interface ITileMap
{
	/**
	 * Intended to return the tile index at the specified coordinate.
	 */
	public function getTileIndex(x:Int, y:Int):Int;
}
