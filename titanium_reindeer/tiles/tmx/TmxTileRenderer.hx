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
		this.tileRenderer = new TileSheetRenderer(null, this.tmxData, 0, 0);
		this.imageLoader = imageLoader;
	}

	/**
	 * Renders a tile of the tmx map given it's global tile id onto the specified canvas. If width
	 * and height are specified the rendered tile will be off that size.
	 */
	public function render(canvas:Canvas2D, tileIndex:Int)
	{
		var chosenTileSet = this.tmxData.getContainingTileSet(tileIndex);
		if (chosenTileSet == null)
			return;

		canvas.save();
		// These lines were causing tiles to be drawn badly hopefully sourceTileHeight is right
		canvas.translatef(
			0,
			this.tmxData.sourceTileHeight - chosenTileSet.tileHeight
		);

		this.tileRenderer.image = this.imageLoader.get(chosenTileSet.imagePath);
		this.tileRenderer.sourceTileWidth = chosenTileSet.tileWidth;
		this.tileRenderer.sourceTileHeight = chosenTileSet.tileHeight;
		this.tileRenderer.render(canvas, tileIndex - chosenTileSet.firstTileId);
		canvas.restore();
	}
}
