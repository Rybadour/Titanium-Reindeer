package titanium_reindeer.tiles.tmx;

class TmxTerrain
{
	public var name:String;
	public var iconTileId:Int;
	
	public var customProperties:Map<String, String>;

	public function new(name:String, iconTileId:Int)
	{
		this.name = name;
		this.iconTileId = iconTileId;
	}
}
