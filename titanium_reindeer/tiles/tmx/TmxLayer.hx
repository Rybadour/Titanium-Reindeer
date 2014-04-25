package titanium_reindeer.tiles.tmx;

/**
 * A class representing a single tile layer of a tmx map file. A layer contains all the information
 * for mapping tile coords to a tile index.
 */
class TmxLayer extends TileMap
{
	/**
	 * The name given to the layer.
	 */
	public var name:String;

	/**
	 * The width in tiles of the layer.
	 */
	public var width:Int;

	/**
	 * The height in tiles of the layer.
	 */
	public var height:Int;

	/**
	 * The x offset of the layer in tiles.
	 * Note: This is apparently deprecated (2014, April).
	 */
	public var layerX:Int;

	/**
	 * The y offset of the layer in tiles.
	 * Note: This is apparently deprecated (2014, April).
	 */
	public var layerY:Int;

	/**
	 * The opacity of the layer and all of it's tiles when rendered.
	 */
	public var opacity:Float;

	/**
	 * A flag which determines if the layer should be rendered.
	 */
	public var visible:Bool;

	public function new(tmxData:TmxData)
	{
		super(tmxData, []);
	}
}
