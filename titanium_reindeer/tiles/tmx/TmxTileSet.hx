package titanium_reindeer.tiles.tmx;

class TmxTileSet
{
	public var firstTileId:Int;
	public var name:String;
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var spacing:Int;
	public var margin:Int;
	public var customProperties:Map<String, String>;

	public var imagePath:String;
	public var imageWidth:Int;
	public var imageHeight:Int;

	public var terrains:Array<TmxTerrain>;

	public var tiles:Array<TmxTile>;

	public function new()
	{
	}
}
