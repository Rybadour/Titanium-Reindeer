package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.IRenderer;
import titanium_reindeer.ui.UIAlignment;
import titanium_reindeer.spatial.Vector2;

class UIElement implements IRenderer
{
	public var position(default, null):Vector2;
	public var alignment:UIAlignment;

	public var width(default, null):Int;
	public var height(default, null):Int;

	public function new(position:Vector2, width:Int = 0, height:Int = 0, alignment)
	{
		this.position = (position == null ? new Vector2(0, 0) : position);
		this.width = width;
		this.height = height;
		this.alignment = (alignment == null ? new UIAlignment(UIAlignX.Left, UIAlignY.Top) : alignment);
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

	public function resize(width:Int, height:Int):Void
	{
		this.width = width;
		this.height = height;
	}
}
