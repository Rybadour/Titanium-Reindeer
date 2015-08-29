package titanium_reindeer.rendering.tiles;

import js.html.Image;
import titanium_reindeer.tiles.TileMapDefinition;

/**
 * This stand-alone renderer uses a tile sheet and the known tile size to render individual tiles by
 * index. Starting from the top left of the image indexing each tile of the specified width and
 * height going towards the bottom right.
 */
class TileSheetRenderer extends UniformTextureAtlas implements ITileRenderer
{
	/**
	 * A definition instance which dictates how big tiles should be rendered.
	 */
	public var definition:TileMapDefinition;

	public function new(tileSheet:Image, definition:TileMapDefinition, sourceTileWidth:Int, sourceTileHeight:Int)
	{
		this.definition = definition;

		super(sourceTileWidth, sourceTileHeight);
    this.image = tileSheet;
	}

	/**
	 * Render a portion of the tile sheet image at the given index.
	 */
	public function render(canvas:Canvas2D, tileIndex:Int):Void
	{
		super.renderTexture(canvas, tileIndex, this.definition.tileWidth, this.definition.tileHeight);
	}
}
