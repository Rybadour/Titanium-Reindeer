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

	public function new(sourceTileWidth:Int, sourceTileHeight:Int)
	{
		this.sourceTileWidth = sourceTileWidth;
		this.sourceTileHeight = sourceTileHeight;
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

    var imageWidth = (this.image == null ? this.imagesCanvas.width : this.image.width);

		var widthInTiles = Math.floor(imageWidth / this.sourceTileWidth);
		// Render the part of the tile sheet that tile Id corresponds to
		var sx = (index % widthInTiles) * this.sourceTileWidth;
		var sy = Math.floor(index / widthInTiles) * this.sourceTileHeight;
    
    canvas.ctx.drawImage(
      untyped __js__('(this.imagesCanvas == null ? this.image : this.imagesCanvas.canvas)'),
      sx, sy,
      this.sourceTileWidth, this.sourceTileHeight,
      0, 0, 
      destinationWidth, destinationHeight
    );
	}
}
