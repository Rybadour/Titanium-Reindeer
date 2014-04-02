package titanium_reindeer.rendering.tiles;

/**
 * This stand-alone renderer uses a tile sheet and the known tile size to render individual tiles by
 * index. Starting from the top left of the image indexing each tile of the specified width and
 * height going towards the bottom right.
 */
class TileRenderer extends ITileRenderer
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

	public function render(canvas:Canvas2D, tileId:Int):Void
	{
		// Render the part of the tile sheet that tile Id corresponds to
	}
}
