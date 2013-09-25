package titanium_reindeer.rendering;

class CanvasRenderer<S:IRenderState> implements ICanvasRenderer<S>
{
	public var state(getState, null):S;
	public function getState():S { return this.state; }

	public var position(getPosition, null):Vector2;
	public function getPosition():Vector2 { return this.position; }


	public function new(state:S)
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
