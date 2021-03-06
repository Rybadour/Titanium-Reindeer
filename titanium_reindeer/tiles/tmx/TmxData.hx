package titanium_reindeer.tiles.tmx;

import titanium_reindeer.rendering.Color;

/**
 * The root storage object for a tmx map. From this class each layer, tile set, and all tmx related
 * information for one map file can be retrieved. A Tmx asset takes a file name and creates one of
 * these objects.
 */
class TmxData extends TileMapDefinition
{
	/**
	 * The version of the format of the tmx file loaded.
	 */
	public var version:String;

	/**
	 * The width of a tile in pixels when the Tmx map was created. This tells us how big relative to
	 * tile sheets the tile grid is.
	 */
	public var sourceTileWidth:Int;

	/**
	 * The height of a tile in pixels when the Tmx map was created. This tells us how big relative to
	 * tile sheets the tile grid is.
	 */
	public var sourceTileHeight:Int;

	/**
	 * The chosen background colour to appear behind the lowest layer.
	 */
	public var backgroundColor:Color;
	
	/**
	 * A set of custom properties attached to the tmx map.
	 */
	public var customProperties:Map<String, String>;

	/**
	 * The tile set objects that represents the tile set file (image) and the tile indexes it
	 * covers.
	 */
	public var tileSets:Array<TmxTileSet>;

	/**
	 * The tile layers ordered from behind to front. They contain the mapping of tile coords to tile
	 * indexes. A tile index in any layer may refer to an tile set.
	 */
	public var layers:Array<TmxLayer>;

	public function getLayer(name:String):TmxLayer
	{
		for (layer in this.layers)
		{
			if (layer.name == name)
				return layer;
		}
		return null;
	}

	/**
	 * Determines the orientation type from the string representation and sets the member to it.
	 */
	public function setOrientation(str:String):Void
	{
		this.orientation = switch (str)
		{
			case "orthogonal":
			   TileMapOrientation.Orthogonal;	
			case "isometric":
			   TileMapOrientation.Isometric(Normal);
			case "staggered":
			   TileMapOrientation.Isometric(Staggered);
			default:
			   TileMapOrientation.Unknown;
		};
	}

	/**
	 * Expects a rgb color value as 6 hex characters preceeded by a #.
	 */
	public function setBackgroundColor(str:String):Void
	{
		if (str == null)
		{
			this.backgroundColor = Color.Clear;
		}
		else
		{
			this.backgroundColor = new Color(
				Std.parseInt('0x' + str.substr(1, 2)),
				Std.parseInt('0x' + str.substr(3, 2)),
				Std.parseInt('0x' + str.substr(5, 2))
			);
		}
	}

	public function getContainingTileSet(tileIndex:Int):TmxTileSet
	{
		var chosenTileSet = null;
		for (tileSet in this.tileSets)
		{
			if (tileSet.firstTileId <= tileIndex)
				chosenTileSet = tileSet;
			else
				break;
		}
		return chosenTileSet;
	}
}
