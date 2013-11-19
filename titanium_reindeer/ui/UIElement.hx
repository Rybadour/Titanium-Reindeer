package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.IRenderer;

class UIElement implements IRenderer
{
	public var position(default, null):Vector2;

	public var width(default, null):Int;
	public var height(default, null):Int;

	public function new()
	{
		this.position = new Vector2(0, 0);
		this.width = 0;
		this.height = 0;
	}

	public function render(canvas:Canvas2D):Void
	{
		this.preRender(canvas);
		this._render(canvas);
		this.postRender(canvas);
	}

	private function preRender(canvas:Canvas2D):Void
	{
		canvas.save();
		canvas.translate(this.position);
	}

	private function _render(canvas:Canvas2D):Void
	{
	}

	private function postRender(canvas:Canvas2D):Void
	{
		canvas.restore();
	}
}
