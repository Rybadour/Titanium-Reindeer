package titanium_reindeer.rendering.tiles;

import js.html.Image;
import titanium_reindeer.tiles.TileMapDefinition;

/**
 * This stand-alone renderer uses a tile sheet and the known tile size to render individual tiles by
 * index. Starting from the top left of the image indexing each tile of the specified width and
 * height going towards the bottom right.
 */
class TileSheetRenderer implements ITileRenderer
{
	/**
	 * An image to render tiles from.
	 */
	public var tileSheet:Image;

	/**
	 * A definition instance which dictates how big tiles should be rendered.
	 */
	public var definition:TileMapDefinition;

	public var sourceTileWidth:Int;
	public var sourceTileHeight:Int;

	public function new(tileSheet:Image, definition:TileMapDefinition, sourceTileWidth:Int, sourceTileHeight:Int)
	{
		this.tileSheet = tileSheet;
		this.definition = definition;
		this.sourceTileWidth = sourceTileWidth;
		this.sourceTileHeight = sourceTileHeight;
	}

	/**
	 * Render a portion of the tile sheet image at the given index.
	 */
	public function render(canvas:Canvas2D, tileIndex:Int):Void
	{
		var widthInTiles = Math.floor(this.tileSheet.width / this.sourceTileWidth);
		// Render the part of the tile sheet that tile Id corresponds to
		var sx = (tileIndex % widthInTiles) * this.sourceTileWidth;
		var sy = Math.floor(tileIndex / widthInTiles) * this.sourceTileHeight;
		canvas.ctx.drawImage(
			tileSheet,
			sx, sy,
			this.sourceTileWidth, this.sourceTileHeight,
			0, 0, 
			this.definition.tileWidth, this.definition.tileHeight
		);
	}
}
