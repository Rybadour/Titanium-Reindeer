package titanium_reindeer.rendering.tiles;

import js.html.Image;

/**
 * This stand-alone renderer uses a tile sheet and the known tile size to render individual tiles by
 * index. Starting from the top left of the image indexing each tile of the specified width and
 * height going towards the bottom right.
 */
class TileSheetRenderer implements ITileRenderer
{
	public var tileSheet:Image;
	public var tileWidth:Int;
	public var tileHeight:Int;

	public function new(tileSheet:Image, tileWidth:Int, tileHeight:Int)
	{
		this.tileSheet = tileSheet;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
	}

	public function render(canvas:Canvas2D, tileIndex:Int, width:Int, height:Int):Void
	{
		var widthInTiles = Math.floor(this.tileSheet.width / this.tileWidth);
		// Render the part of the tile sheet that tile Id corresponds to
		var sx = (tileIndex % widthInTiles) * this.tileWidth;
		var sy = Math.floor(tileIndex / widthInTiles) * this.tileHeight;
		canvas.ctx.drawImage(tileSheet,
			sx, sy,
			this.tileWidth, this.tileHeight,
			0, 0, 
			width, height
		);
	}
}
