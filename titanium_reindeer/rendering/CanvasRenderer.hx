package titanium_reindeer.rendering;

class CanvasRenderer extends Renderer<RenderState>
{
	public var canvas(default, null):Canvas2D;

	public function new(canvas:Canvas2D)
	{
		super(new RenderState());

		this.canvas = canvas;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		canvas.renderCanvas(this.canvas);
	}
}
