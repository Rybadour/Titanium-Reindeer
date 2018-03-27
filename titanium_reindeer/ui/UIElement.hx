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

	public function new(width:Int = 0, height:Int = 0)
	{
		this.position = new Vector2(0, 0);
		this.width = width;
		this.height = height;
		this.alignment = new UIAlignment(UIAlignX.Left, UIAlignY.Top);
	}

	public function relativeTo(pos:Vector2):Vector2
	{
		// TODO: Handle alignment
		return pos.subtract(this.position);
	}

	public function isMouseOver(pos:Vector2):Bool
	{
		var relative = this.relativeTo(pos);
		return (relative.x >= 0 && relative.x <= this.width &&
		        relative.y >= 0 && relative.y <= this.height);
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
