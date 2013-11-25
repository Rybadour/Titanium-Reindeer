package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.IRenderer;
import titanium_reindeer.ui.UIAlignment;

class UIElement implements IRenderer
{
	public var position(default, null):Vector2;
	public var alignment:UIAlignment;

	public var width(default, null):Int;
	public var height(default, null):Int;

	public function new()
	{
		this.position = new Vector2(0, 0);
		this.width = 0;
		this.height = 0;
		this.alignment = new UIAlignment(UIAlignX.Left, UIAlignY.Top);
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
		this.applyOffset(canvas);
	}

	private function _render(canvas:Canvas2D):Void
	{
	}

	private function postRender(canvas:Canvas2D):Void
	{
		canvas.restore();
	}

	private function applyOffset(canvas:Canvas2D):Void
	{
		canvas.translate(this.position);

		canvas.translate( this.alignment.getFromSize(this.width, this.height).getReverse() );
	}
}
