package titanium_reindeer.tiles.tmx;

/**
 * A class representing the configuration that represents a terrain in the tmx map.
 */
class TmxTerrain
{
	/**
	 * The name given to the terrain.
	 */
	public var name:String;

	/**
	 * The index of the tile used to present the terrain visually.
	 */
	public var iconTileId:Int;
	
	/**
	 * A set of custom properties given to the terrain.
	 */
	public var customProperties:Map<String, String>;

	public function new(name:String, iconTileId:Int)
	{
		this.name = name;
		this.iconTileId = iconTileId;
	}
}
