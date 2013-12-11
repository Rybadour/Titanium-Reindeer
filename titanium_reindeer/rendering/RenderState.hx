package titanium_reindeer.rendering;

class RenderState implements IRenderState
{
	public var alpha(default, set):Float;
	private function set_alpha(value:Float):Float
	{
		if (value < 0)
			value = 0;
		else if (value > 1)
			value = 1;

		if (value != this.alpha)
		{
			this.alpha = value;
		}

		return this.alpha;
	}

	public var shadow(default, set):Shadow;
	private function set_shadow(value:Shadow):Shadow
	{
		if (value != null)
		{
			if (this.shadow == null || !value.equal(this.shadow))
			{
				this.shadow = value;
			}
		}

		return this.shadow;
	}

	public var rotation(default, set):Float;
	private function set_rotation(value:Float):Float
	{
		 value %= Math.PI*2;

		if (value != this.rotation)
		{
			this.rotation = value;
		}

		return this.rotation;
	}

	public function new()
	{
		this.alpha = 1;
		this.rotation = 0;
	}

	public function apply(canvas:Canvas2D):Void
	{
		//canvas.ctx.globalCompositeOperation = RendererComponent.CompositionToString(this.renderComposition);

		if (this.rotation != 0)
			canvas.ctx.rotate(this.rotation);

		canvas.ctx.globalAlpha = this.alpha;

		if (this.shadow != null)
		{
			canvas.ctx.shadowColor = this.shadow.color.rgba;
			canvas.ctx.shadowOffsetX = this.shadow.offset.x;
			canvas.ctx.shadowOffsetY = this.shadow.offset.y;
			canvas.ctx.shadowBlur = this.shadow.blur;
		}
	}
}
