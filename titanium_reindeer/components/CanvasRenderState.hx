package titanium_reindeer.components;

import titanium_reindeer.Shadow;
import titanium_reindeer.core.Watcher;

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

		if (value != this.alpha)
		{
			this.alpha = value;
		}

		return this.alpha;
	}

	public var shadow(default, setShadow):Shadow;
	private function setShadow(value:Shadow):Shadow
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

	public var rotation(default, setRotation):Float;
	private function setRotation(value:Float):Float
	{
		 value %= Math.PI*2;

		if (value != this.rotation)
		{
			this.rotation = value;
		}

		return this.rotation;
	}

	private var position:Watcher<Vector2>;
	public var localPosition(getLocalPosition, setLocalPosition):Vector2;
	private function getLocalPosition():Vector2 { return this.position.value; }
	private function setLocalPosition(value:Vector2):Vector2
	{
		this.position.value = value;
		return this.position.value;
	}

	public function new(renderFunc:Canvas2D -> Void)
	{
		this.renderFunc = renderFunc;

		this.alpha = 1;
		this.rotation = 0;

		this.position = new Watcher(new Vector2(0, 0));
	}

	private function preRender(canvas:Canvas2D):Void
	{
		canvas.ctx.save();
		//canvas.ctx.globalCompositeOperation = RendererComponent.CompositionToString(this.renderComposition);

		/* *
		canvas.ctx.translate(this.screenPos.x, this.screenPos.y);
		if (this.rotation != 0)
		{
			canvas.ctx.rotate(this.rotation);
		}
		/* */

		canvas.ctx.globalAlpha = this.alpha;

		if (this.shadow != null)
		{
			canvas.ctx.shadowColor = this.shadow.color.rgba;
			canvas.ctx.shadowOffsetX = this.shadow.offset.x;
			canvas.ctx.shadowOffsetY = this.shadow.offset.y;
			canvas.ctx.shadowBlur = this.shadow.blur;
		}
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
