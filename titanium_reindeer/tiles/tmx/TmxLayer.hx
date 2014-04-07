package titanium_reindeer.tiles.tmx;

class TmxLayer extends TileMap
{
	public var name:String;
	public var layerX:Int;
	public var layerY:Int;
	public var opacity:Float;
	public var visible:Bool;

	public function new()
	{
		super([], 0, 0);
	}
}
