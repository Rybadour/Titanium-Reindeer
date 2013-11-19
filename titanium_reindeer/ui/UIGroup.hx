package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.util.Tuple;

class UIGroup extends UIElement
{
	public var children(default, null):Array< Tuple3<UIElement, UIPositioning, UIPositioning> >;

	public function new()
	{
		super();

		this.children = new Array();
	}

	public function addChild(e:UIElement, at:UIPositioning, my:UIPositioning)
	{
		this.children.push(new Tuple3(e, at, my));
	}

	private override function _render(canvas:Canvas2D):Void
	{
		for (child in children)
		{
			var ele = child.first;
			var at = child.second;
			var my = child.third;

			var atOffset = at.getElementOffset(this);
			var myOffset = my.getElementOffset(ele);

			canvas.translate( atOffset.add(myOffset) );
			ele.render(canvas);
		}
	}
}
