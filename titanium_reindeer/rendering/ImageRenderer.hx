package titanium_reindeer.rendering;

import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IRegion;
import titanium_reindeer.core.RectRegion;

class ImageRenderer extends Renderer
{
	public var image(default, setImage):ImageSource;
	private function setImage(value:ImageSource):ImageSource
	{
		if (value != this.image)
		{
			this.image = value;
			if (this.image.isLoaded)
				this.imageLoaded();
		}

		return this.image;
	}

	public function new(image:ImageSource)
	{
		super(new RenderState());

		this.image = image;
		if (!this.image.isLoaded)
			this.image.registerLoadEvent(imageLoaded);
	}

	public function _render(canvas:Canvas2D):Void
	{
		canvas.ctx.drawImage(
			this.image.image,
			0, 0,
			this.image.width, this.image.height
		);
	}
}
