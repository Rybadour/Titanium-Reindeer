package titanium_reindeer.tiles.tmx;

class TmxTile
{
	public var id:Int;
	public var terrainTopLeft:Int;
	public var terrainTopRight:Int;
	public var terrainBottomLeft:Int;
	public var terrainBottomRight:Int;
	public var terrainProbability:Float;

	public var customProperties:Map<String, String>;

	public function new(id:Int)
	{
		this.id = id;
	}
}
