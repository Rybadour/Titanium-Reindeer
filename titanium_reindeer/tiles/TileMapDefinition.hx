package titanium_reindeer.tiles;

class TileMapDefinition
{
	/**
	 * The tile orientation of each layer of this tmx file.
	 */
	public var orientation:TileMapOrientation;

	/**
	 * The width in tiles of the map and all layers
	 */
	public var width:Int;

	/**
	 * The height in tiles of the map and all layers
	 */
	public var height:Int;

	/**
	 * The width of a column of the tile map for alignment purposed only. Individual tiles may be
	 * drawn larger or smaller but will be anchored to the bottom left.
	 */
	public var tileWidth:Int;

	/**
	 * The height of a row of the tile map for alignment purposed only. Individual tiles may be drawn
	 * larger or smaller but will be anchored to the bottom left.
	 */
	public var tileHeight:Int;
}
