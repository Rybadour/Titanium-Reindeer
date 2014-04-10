package titanium_reindeer.rendering.tiles;

import titanium_reindeer.tiles.ITileMap;
import titanium_reindeer.rendering.RepeatFillRenderer;

/**
 * A basic implemention of how to render all of the tiles of a given tile map using a given tile
 * renderer. There is an assumed relationship between the tile indices provided by the tile map and
 * the tile indices the tile renderer is capable of rendering.
 */
class TileMapRenderer extends RepeatFillRenderer
{
	/**
	 * The object queried for a tile id at a given tile position (x, y).
	 */
	public var tileMap:ITileMap;

	/**
	 * The object for rendering one tile based on a given tile Id.
	 */
	public var tileRenderer:ITileRenderer;

	public function new(width:Int, height:Int, tileWidth:Int, tileHeight:Int, tileMap:ITileMap, tileRenderer:ITileRenderer)
	{
		super(width, height, RepeatFillMethod.Both, tileWidth, tileHeight);

		this.tileMap = tileMap;
		this.tileRenderer = tileRenderer;
	}

	/**
	 * Render the tile at position x, y. This method is called when render for each portion of the
	 * total space.
	 */
	private override function renderTile(x:Int, y:Int, canvas:Canvas2D):Void
	{
		// Add the offset to obtain the x and y of the tile relative to the tile map.
		x += Math.floor(this.offset.x / this.sourceWidth);
		y += Math.floor(this.offset.y / this.sourceHeight);

		var tileIndex = this.tileMap.getTileIndex(x, y);
		this.tileRenderer.render(canvas, tileIndex);
	}
}
