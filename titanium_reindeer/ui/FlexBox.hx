package titanium_reindeer.ui;

typedef FlexChild = {
	var element:UIElement;
	var margin:UIMargin;
}

class FlexBox extends UIElement
{
	public function new(width:Int, height:Int, children:Array<FlexChild>, direction:FlexDirection, wrap:FlexWrap)
	{
		super(width, height);

		this.children = children;
	}

	private override function _render(canvas:Canvas2D):Void
	{
	}

}
