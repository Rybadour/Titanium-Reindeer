package titanium_reindeer.rendering.tiles;

import titanium_reindeer.rendering.RepeatFillRenderer;

class TileMapRenderer extends RepeatFillRenderer
{
	/**
	 * The object queried for a tile id at a given tile position (x, y).
	 */
	public var tileMap:TileMap;

	/**
	 * The object for rendering one tile based on a given tile Id.
	 */
	public var tileRenderer:ITileRenderer;

	public function new(width:Int, height:Int, tileMap:TileMap, tileRenderer:ITileRenderer)
	{
		super(width, height, RepeatFillMethod.Both, provider.tileWidth, provider.tileHeight);

		this.tileMap = tileMap;
		this.tileRenderer = tileRenderer;
	}

	private override function renderTile(x:Int, y:Int, canvas:Canvas2D):Void
	{
		// Add the offset to obtain the x and y of the tile relative to the tile map.
		x += Math.floor(this.offset.x / this.sourceWidth);
		y += Math.floor(this.offset.y / this.sourceHeight);

		var tileId = this.tileProvider.getTileId(x, y);
		this.tileRenderer.render(canvas, tileId);
	}
}
