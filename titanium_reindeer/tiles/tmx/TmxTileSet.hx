package titanium_reindeer.tiles.tmx;

/**
 * A class representing the visible image data mapped to a global tile index. The tile set image is
 * divided up into cells of the specified tileWidth and tileHeight. The index for any tile on
 * this sheet starts at 0 for the cell at the top left increases first to the right then down row by
 * row. The global tile index is the local tile index plus the firstTileId.
 */
class TmxTileSet
{
	/**
	 * The global tile index of the top-left cell of this tile set.
	 */
	public var firstTileId:Int;

	/**
	 * The name given to this tile set.
	 */
	public var name:String;

	/**
	 * The (maximum) width of the tiles in this tile set.
	 */
	public var tileWidth:Int;

	/**
	 * The (maximum) height of the tiles in this tile set.
	 */
	public var tileHeight:Int;

	/**
	 * The spacing in pixels between the tiles in this tile set.
	 */
	public var spacing:Int;

	/**
	 * The margin around the tiles in this tile set.
	 */
	public var margin:Int;

	/**
	 * A set of custom properties.
	 */
	public var customProperties:Map<String, String>;

	/**
	 * The file path to the image used by this tile set. This path is relative to the tmx file's
	 * path.
	 */
	public var imagePath:String;

	/**
	 * The image width in pixels.
	 */
	public var imageWidth:Int;

	/**
	 * The image height in pixels.
	 */
	public var imageHeight:Int;

	/**
	 * An array of terrains designed for this tile set.
	 */
	public var terrains:Array<TmxTerrain>;

	/**
	 * The tiles of terrains as an array of tiles with the tile's corners each referring to a
	 * terrain type.
	 */
	public var tiles:Array<TmxTile>;

	public function new()
	{
	}
}
