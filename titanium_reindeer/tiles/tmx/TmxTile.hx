package titanium_reindeer.tiles.tmx;

/**
 * A class representing a single tile in a terrain.
 */
class TmxTile
{
	/**
	 * The global tile index.
	 */
	public var id:Int;

	/**
	 * The terrain id this tile's top left corner belongs to.
	 */
	public var terrainTopLeft:Int;

	/**
	 * The terrain id this tile's top right corner belongs to.
	 */
	public var terrainTopRight:Int;

	/**
	 * The terrain id this tile's bottom left corner belongs to.
	 */
	public var terrainBottomLeft:Int;

	/**
	 * The terrain id this tile's bottom right corner belongs to.
	 */
	public var terrainBottomRight:Int;

	/**
	 * The probability that this tile will be chosen when painting a terrain it belongs to.
	 */
	public var terrainProbability:Float;

	/**
	 * A set of custom properties associated with this terrain tile.
	 */
	public var customProperties:Map<String, String>;

	public function new(id:Int)
	{
		this.id = id;
	}
}
