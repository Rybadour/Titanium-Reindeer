package titanium_reindeer.ui;

import titanium_reindeer.rendering.IRenderer;
import titanium_reindeer.rendering.Canvas2D;

class UIView extends UIElement 
{
	public var view(default, null):IRenderer;

	public function new(view:IRenderer)
	{
		super();

		this.view = view;
	}

	private function calculateSize(canvas:Canvas2D):Void
	{
	}

	private override function preRender(canvas:Canvas2D):Void
	{
		this.calculateSize(canvas);
		super.preRender(canvas);
	}

	private override function _render(canvas:Canvas2D):Void
	{
		this.view.render(canvas);
	}
}
