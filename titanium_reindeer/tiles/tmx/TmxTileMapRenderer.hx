package titanium_reindeer.tiles.tmx;

import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.rendering.*;
import titanium_reindeer.rendering.tiles.TileMapRenderer;
import titanium_reindeer.assets.ImageLoader;

/**
 * A class which will render and entire tmx map. This class renders the background colour first then
 * all the visible layers with their specified opacity.
 */
class TmxTileMapRenderer extends Renderer<RenderState>
{
	/**
	 * The drawn width of the renderer. Will clip tiles outside this width and draw the background
	 * colour over the entire size.
	 */
	public var width:Int;

	/**
	 * The drawn height of the renderer. Will clip tiles outside this and draw the background
	 * colour over the entire size.
	 */
	public var height:Int;

	/**
	 * The tmx map to render.
	 */
	public var tmxData:TmxData;

	/**
	 * The internal offset that layers of the tile map are drawn with.
	 */
	public var offset:Vector2;

	/**
	 * Using a basic tile renderer to render one layer at a time.
	 */
	public var layerRenderer:TileMapRenderer;

	/**
	 * A single tmx tile renderer instance to render any tile index of the tmx map.
	 */
	public var tmxTileRenderer:TmxTileRenderer;

	public function new(width:Int, height:Int, tmxData:TmxData, images:ImageLoader)
	{
		this.width = width;
		this.height = height;

		this.tmxData = tmxData;
		this.tmxTileRenderer = new TmxTileRenderer(tmxData, images);
		this.layerRenderer = new TileMapRenderer(
			width,
			height,
			tmxData.tileWidth,
			tmxData.tileHeight,
			null,
			this.tmxTileRenderer
		);

		super(new RenderState());
	}

	/**
	 * Render the tile at position x, y. This method is called when render for each portion of the
	 * total space.
	 */
	private override function _render(canvas:Canvas2D):Void
	{
		canvas.save();
		canvas.fillColor(this.tmxData.backgroundColor);
		canvas.renderRectf(this.width, this.height);
		canvas.restore();

		canvas.save();
		canvas.translate(this.offset);
		for (layer in this.tmxData.layers)
		{
			if (layer.visible)
			{
				canvas.save();
				this.layerRenderer.state.alpha = layer.opacity;
				this.layerRenderer.tileMap = layer;
				this.layerRenderer.render(canvas);
				canvas.restore();
			}
		}
		canvas.restore();
	}
}
