package titanium_reindeer.rendering;

enum RepeatFillMethod
{
	Horizontal;
	Vertical;
	Both;
}

class RepeatFillRenderer extends Renderer<RenderState>
{
	public var offset:Vector2;
	public var renderer:Renderer

	public function new(r:IRenderer, width:Float, height:Float, repeat ?sWidth:Float, ?sHeight:Float)
	{
		super(new RenderState());

		this.offset = new Vector2(0, 0);
		this.renderer = r;
		this.destWidth = width;
		this.destHeight = height;
		this.sourceWidth = (sWidth == null) ? width : sWidth;
		this.sourceHeight = (sHeight == null) ? height : sHeight;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		var temp = new Canvas2D("temp", this.width, this.height);

		for (
		temp.
		canvas.translate(0, 0);
	}
}
