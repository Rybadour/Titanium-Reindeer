package titanium_reindeer.rendering;

class CanvasRenderer implements ICanvasRenderer
{
	public var state(getState, null):IRenderState;
	public function getState():IRenderState { return this.state; }

	public var position(getPosition, null):Vector2;
	public function getPosition():Vector2 { return this.position; }


	public function new(state:IRenderState)
	{
		this.position = new Vector2(0, 0);
		this.state = state;
	}

	public function render(canvas:Canvas2D):Void
	{
		canvas.ctx.save();
		canvas.ctx.translate(this.position.x, this.position.y);
		this.state.apply(canvas);
		this._render(canvas);
		canvas.ctx.restore();
	}

	private function _render(canvas:Canvas2D):Void { }
}
