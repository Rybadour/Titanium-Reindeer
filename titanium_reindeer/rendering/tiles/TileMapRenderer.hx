package titanium_reindeer.rendering.tiles;

import titanium_reindeer.rendering.RepeatFillRenderer;

class TileMapRenderer extends RepeatFillRenderer
{
	/**
	 * The object queried for a tile asset at a given tile position (x, y).
	 */
	public var tileProvider:TileMap;

	/**
	 * The single ImageRenderer instance responsible for rendering a tile at each position.
	 */
	public var tileRenderer:ImageRenderer;

	public function new(width:Int, height:Int, provider:TileMap)
	{
		super(null, width, height, RepeatFillMethod.Both, provider.tileWidth, provider.tileHeight, this.tileMappingFunc);

		this.tileProvider = provider;
		this.tileRenderer = new ImageRenderer(null);
	}

	private function tileMappingFunc(x:Int, y:Int):ImageRenderer
	{
		this.tileRenderer.image = this.tileProvider.getTileImage(x, y);
		return this.tileRenderer;
	}
}
