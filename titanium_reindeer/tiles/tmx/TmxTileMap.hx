package titanium_reindeer.tiles.tmx;

class TmxTileMap extends TileMap
{
	public var tmxLayer:TmxLayer;

	public function new(tmxLayer:TmxLayer)
	{
		this.tmxLayer = tmxLayer;

		super(this.tmxLayer.tileIds, this.tmxLayer.width, this.tmxLayer.height);
	}

