package titanium_reindeer.tiles.tmx;

class TmxExternalTypesMapping extends TileMapping
{
	public var mainTmx:TmxData;
	public var typesTmx:TmxData;

	public var cachedTileMapping:Map<Int, Array<String>>;

	public function new(mainTmx:TmxData, layer:String, typesTmx:TmxData)
	{
		this.mainTmx = mainTmx;
		this.typesTmx = typesTmx;
		this.generateMapping();

		super(this.mainTmx.getLayer(layer));
	}

	private function generateMapping():Void
	{
		this.cachedTileMapping = new Map();
		for (layer in this.typesTmx.layers)
		{
			for (tileIndex in layer.tileIndices)
			{
				tileIndex = this.getRelativeTileIndex(tileIndex);
				if (tileIndex == null)
					continue;

				if (this.cachedTileMapping.exists(tileIndex))
					this.cachedTileMapping.get(tileIndex).push(layer.name);
				else
					this.cachedTileMapping.set(tileIndex, [layer.name]);
			}
		}
	}

	private function getRelativeTileIndex(tileIndex:Int):Int
	{
		var tileSet = this.mainTmx.getContainingTileSet(tileIndex);
		if (tileSet == null)
			return null;

		return tileIndex - tileSet.firstTileId;
	}

	public override function _map(tileIndex:Int):Array<String>
	{
		tileIndex = this.getRelativeTileIndex(tileIndex);
		return (tileIndex == null ? null : this.cachedTileMapping.get(tileIndex));
	}

}
