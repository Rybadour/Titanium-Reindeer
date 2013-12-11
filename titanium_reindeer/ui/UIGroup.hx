package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.util.Tuple;

class UIGroup extends UIElement
{
	public var children(default, null):Array< Tuple<UIElement, UIAlignment> >;

	public function new()
	{
		super();

		this.children = new Array();
	}

	public function addChild(e:UIElement, a:UIAlignment)
	{
		this.children.push(new Tuple(e, a));
	}

	private override function _render(canvas:Canvas2D):Void
	{
		for (child in children)
		{
			canvas.save();
			this.applyChildAlign(child.second, canvas);
			this.renderChild(child.first, canvas);
			canvas.restore();
		}
	}

	private function applyChildAlign(a:UIAlignment, canvas:Canvas2D):Void
	{
		canvas.translate(a.getFromSize(this.width, this.height));
	}

	private function renderChild(e:UIElement, canvas:Canvas2D):Void
	{
		e.render(canvas);
	}
}
