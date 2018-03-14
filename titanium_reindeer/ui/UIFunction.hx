package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;

class UIFunction extends UIElement
{
	public var func:Canvas2D -> Void;
	
	public function new(width:Int, height:Int, func:Canvas2D -> Void)
	{
		super(width, height);

		this.func = func;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		this.func(canvas);
	}
}
