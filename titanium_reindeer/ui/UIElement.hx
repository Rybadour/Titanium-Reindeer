package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.IRenderer;

class UIElement implements IRenderer
{
	public var width(default, null):Int;
	public var height(default, null):Int;

	public function new(width:Int = 0, height:Int = 0)
	{
		this.width = width;
		this.height = height;
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
	}

	private function _render(canvas:Canvas2D):Void
	{
	}

	private function postRender(canvas:Canvas2D):Void
	{
		canvas.restore();
	}

	public function resize(width:Int, height:Int):Void
	{
		this.width = width;
		this.height = height;
	}
}
