package titanium_reindeer.rendering;

import js.html.Image;

class ImageTileAtlas extends UniformTextureAtlas
{
	public function new(image:Image, tileWidth:Int, tileHeight:Int)
	{
		this.image = image;

		super(tileWidth, tileHeight);
		this.createCanvas(this.image.width, this.image.height);
		this.imagesCanvas.renderImage(this.image);
	}
}
