package titanium_reindeer.components;

class CanvasRenderState
{
	private var renderFunc:Canvas2D -> Void;

	public var alpha(default, setAlpha):Float;
	private function setAlpha(value:Float):Float
	{
		if (value < 0)
			value = 0;
		else if (value > 1)
			value = 1;

		if (value != alpha)
		{
			alpha = value;
			this.timeForRedraw = true;
		}

		return alpha;
	}

	public function new(renderFunc:Canvas2D -> Void)
	{
		this.renderFunc = renderFunc;
		this.alpha = 0;
	}

	private function preRender(canvas:Canvas2D):Void
	{
		canvas.ctx.save();
		canvas.ctx.globalCompositeOperation = RendererComponent.CompositionToString(this.renderComposition);

		/* *
		canvas.ctx.translate(this.screenPos.x, this.screenPos.y);
		if (this.rotation != 0)
		{
			canvas.ctx.rotate(this.rotation);
		}
		/* */

		canvas.ctx.globalAlpha = this.alpha;

		canvas.ctx.shadowColor = this.shadow.color.rgba;
		canvas.ctx.shadowOffsetX = this.shadow.offset.x;
		canvas.ctx.shadowOffsetY = this.shadow.offset.y;
		canvas.ctx.shadowBlur = this.shadow.blur;
	}

	public function render(canvas:Canvas2D):Void
	{
		this.preRender(canvas);
		this.renderFunc(canvas);
		this.postRender(canvas);
	}

	private function postRender(canvas:Canvas2D):Void
	{
		canvas.ctx.restore();
	}
}
