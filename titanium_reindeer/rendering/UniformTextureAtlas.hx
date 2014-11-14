package titanium_reindeer.rendering;

import js.html.Image;

/**
 * TODO: EXPLAIN
 */
class UniformTextureAtlas implements ITextureAtlas
{
	/**
	 * An image to render tiles from.
	 */
	public var image:Image;

	public var sourceTileWidth:Int;
	public var sourceTileHeight:Int;

	public function new(image:Image, sourceTileWidth:Int, sourceTileHeight:Int)
	{
		this.image = image;
		this.sourceTileWidth = sourceTileWidth;
		this.sourceTileHeight = sourceTileHeight;
	}

	/**
	 * Render a portion of the atlas image at the given index.
	 */
	public function renderTexture(canvas:Canvas2D, index:Int, destinationWidth:Int, destinationHeight:Int):Void
	{
		var widthInTiles = Math.floor(this.image.width / this.sourceTileWidth);
		// Render the part of the tile sheet that tile Id corresponds to
		var sx = (index % widthInTiles) * this.sourceTileWidth;
		var sy = Math.floor(index / widthInTiles) * this.sourceTileHeight;
		canvas.ctx.drawImage(
			this.image,
			sx, sy,
			this.sourceTileWidth, this.sourceTileHeight,
			0, 0, 
			destinationWidth, destinationHeight
		);
	}
}
