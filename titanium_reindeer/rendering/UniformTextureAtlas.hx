package titanium_reindeer.rendering;

import js.html.Image;

/**
 * UniformTextureAtlas is a class that encompasses a composite image of smaller images laid out in a
 * uniform grid. The atlas allows easy rendering of portions of the composite.
 */
class UniformTextureAtlas implements ITextureAtlas
{
	public var imagesCanvas:Canvas2D;
	public var image:Image;

	public var sourceTileWidth:Int;
	public var sourceTileHeight:Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var tileMarginX:Int;
	public var tileMarginY:Int;
	public var widthInTiles:Int;

	public function new(
			sourceTileWidth:Int, sourceTileHeight:Int,
			offsetX:Int = 0, offsetY:Int = 0,
			tileMarginX:Int = 0, tileMarginY:Int = 0,
			widthInTiles:Int = null
	)
	{
		this.sourceTileWidth = sourceTileWidth;
		this.sourceTileHeight = sourceTileHeight;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.tileMarginX = tileMarginX;
		this.tileMarginY = tileMarginY;
		this.widthInTiles = widthInTiles;
	}

	public function createCanvas(width:Int, height:Int)
	{
		this.imagesCanvas = new Canvas2D("tileImages", width, height);
	}

	/**
	 * Render a portion of the atlas image at the given index.
	 */
	public function renderTexture(canvas:Canvas2D, index:Int, destinationWidth:Int, destinationHeight:Int):Void
	{
		if (this.image == null && this.imagesCanvas == null)
		  return;

		var imageWidth = (this.image == null ? this.imagesCanvas.width : this.image.width) - offsetX;

		var widthInTiles = this.widthInTiles;
		if (widthInTiles == null)
		{
			var widthLeft = imageWidth;
			var tiles = 0;
			while (widthLeft > 0) {
				widthLeft -= this.sourceTileWidth;
				if (widthLeft <= 0)
					break;
				tiles++;
				widthLeft -= this.tileMarginX;
			}
		}
		// Render the part of the tile sheet that tile Id corresponds to
		var sx = (index % widthInTiles) * (this.sourceTileWidth + this.tileMarginX) + offsetX;
		var sy = Math.floor(index / widthInTiles) * (this.sourceTileHeight + this.tileMarginY) + offsetY;
		
		canvas.ctx.drawImage(
		  untyped __js__('(this.imagesCanvas == null ? this.image : this.imagesCanvas.canvas)'),
		  sx, sy,
		  this.sourceTileWidth, this.sourceTileHeight,
		  0, 0, 
		  destinationWidth, destinationHeight
		);
	}
}
