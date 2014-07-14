package titanium_reindeer.tiles.tmx;

class TmxHitTestMapping extends TileMapping
{
	public var tmxData:TmxData;

	public function new(tmx:TmxData, layer:String)
	{
		this.tmxData = tmx;
		super(tmx.getLayer(layer));
	}

	private override function _map(tileIndex:Int):Array<String>
	{
		var tileSet = this.tmxData.getContainingTileSet(tileIndex);
		if (tileSet == null)
			return null;

		return ["hit"];
	}
}
