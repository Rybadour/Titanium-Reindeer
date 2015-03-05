package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;

class UIGroup extends UIElement
{
	public var children(default, null):Array<{element:UIElement, alignment:UIAlignment}>;

	public function new()
	{
		super();

		this.children = new Array();
	}

	public function addChild(e:UIElement, a:UIAlignment)
	{
		this.children.push({element: e, alignment: a});
	}

	private override function _render(canvas:Canvas2D):Void
	{
		for (child in children)
		{
			canvas.save();
			this.applyChildAlign(child.alignment, canvas);
			this.renderChild(child.element, canvas);
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
