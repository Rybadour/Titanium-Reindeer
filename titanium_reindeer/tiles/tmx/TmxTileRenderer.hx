package titanium_reindeer.tiles.tmx;

import titanium_reindeer.rendering.tiles.ITileRenderer;
import titanium_reindeer.rendering.tiles.TileSheetRenderer;
import titanium_reindeer.assets.ImageLoader;
import titanium_reindeer.rendering.*;

/**
 * A class used to render tiles of tmx map. It uses TileSheetRenderer internally to render a tile
 * given a global tile index of the tmx map. The global tile index of a tmx map is taken and made
 * relative to the tile set it needs to render from.
 */
class TmxTileRenderer implements ITileRenderer
{
	/**
	 * The tmx map.
	 */
	public var tmxData:TmxData;

	/**
	 * The TileSheetRenderer instance used to do the coord mapping relative to a given tile set.
	 */
	public var tileRenderer:TileSheetRenderer;

	/**
	 * The ImageLoader instance assumed to have loaded (and containing) the images of all the tile
	 * sets.
	 */
	public var imageLoader:ImageLoader;

	public function new(tmxData:TmxData, imageLoader:ImageLoader)
	{
		this.tmxData = tmxData;
		this.tileRenderer = new TileSheetRenderer(null, tmxData.tileWidth, tmxData.tileHeight);
		this.imageLoader = imageLoader;
	}

	/**
	 * Renders a tile of the tmx map given it's global tile id onto the specified canvas. If width
	 * and height are specified the rendered tile will be off that size.
	 */
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

		canvas.save();
		canvas.translatef(
			0,//this.tmxData.tileWidth - chosenTileSet.tileWidth,
			this.tmxData.tileHeight - chosenTileSet.tileHeight
		);

		this.tileRenderer.tileSheet = this.imageLoader.get(chosenTileSet.imagePath);
		this.tileRenderer.tileWidth = chosenTileSet.tileWidth;
		this.tileRenderer.tileHeight = chosenTileSet.tileHeight;
		this.tileRenderer.render(canvas, tileIndex - chosenTileSet.firstTileId);
		canvas.restore();
	}
}
