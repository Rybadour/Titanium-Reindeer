package titanium_reindeer.tiles.tmx;

class TmxTileRenderer implements ITileRenderer
{
	public var tmxData:TmxData;
	public var tileRenderer:TileSheetRenderer;

	public function new(tmxData:TmxData, imageLoader:ImageLoader)
	{
		this.tmxData = tmxData;
		this.tileRenderer = new TileSheetRenderer(null, tmxData.tileWidth, tmxData.tileHeight);
	}

	public function render(canvas:Canvas2D, tileIndex:Int)
	{
		var chosenTileSet = null;
		for (tileSet in this.tmxData.tileSets)
		{
			if (tileSet.firstTileId <= tileIndex)
				chosenTileSet = tileSet;
			else
				break;
		}

		if (chosenTileSet == null)
			return;

		this.tileRenderer.tileSheet = this.imageLoader.get(chosenTileSet.imagePath);
		this.tileRenderer.render(canvas, tileIndex - chosenTileSet.firstTileId);
	}
}
