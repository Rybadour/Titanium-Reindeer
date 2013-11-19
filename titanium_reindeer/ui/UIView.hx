package titanium_reindeer.ui;

import titanium_reindeer.rendering.IRenderer;
import titanium_reindeer.rendering.Canvas2D;

class UIView extends UIElement 
{
	public var view(default, null):IRenderer;

	public function new(view:IRenderer)
	{
		this.view = view;
	}

	public function calculateSize(canvas:Canvas2D):Void
	{
		this.width = 0;
		this.height = 0;
	}

	private function preRender(canvas:Canvas2D):Void
	{
		this.calculateSize(canvas);

		super.preRender(canvas);
	}

	private function _render(canvas:Canvas2D):Void
	{
		this.view.render(canvas);
	}
}
