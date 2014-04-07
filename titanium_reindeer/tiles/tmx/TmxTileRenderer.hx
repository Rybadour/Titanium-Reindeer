package titanium_reindeer.tiles.tmx;

import titanium_reindeer.rendering.tiles.ITileRenderer;
import titanium_reindeer.rendering.tiles.TileSheetRenderer;
import titanium_reindeer.assets.ImageLoader;
import titanium_reindeer.rendering.*;

class TmxTileRenderer implements ITileRenderer
{
	public var tmxData:TmxData;
	public var tileRenderer:TileSheetRenderer;
	public var imageLoader:ImageLoader;

	public function new(tmxData:TmxData, imageLoader:ImageLoader)
	{
		this.tmxData = tmxData;
		this.tileRenderer = new TileSheetRenderer(null, tmxData.tileWidth, tmxData.tileHeight);
		this.imageLoader = imageLoader;
	}

	public function render(canvas:Canvas2D, tileIndex:Int, width:Int, height:Int)
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
		this.tileRenderer.render(canvas, tileIndex - chosenTileSet.firstTileId, width, height);
	}
}
