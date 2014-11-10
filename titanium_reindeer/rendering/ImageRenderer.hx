package titanium_reindeer.rendering;

import js.html.Image;

class ImageRenderer extends Renderer<RenderState>
{
	public var image:Image;

	public function new(image:Image)
	{
		super(new RenderState());

		this.image = image;
	}

	public override function _render(canvas:Canvas2D):Void
	{
		canvas.ctx.drawImage(
			this.image,
			0, 0,
			this.image.width, this.image.height
		);
	}
}
