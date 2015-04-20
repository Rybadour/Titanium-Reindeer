package titanium_reindeer.rendering;

import js.html.Image;

class ImageTileAtlas extends UniformTextureAtlas
{
	public var image:Image;

	public function new(image:Image, tileWidth:Int, tileHeight:Int)
	{
		this.image = image;

		super(tileWidth, tileHeight, image.width, image.height);
		this.imagesCanvas.renderImage(this.image);
	}
}
