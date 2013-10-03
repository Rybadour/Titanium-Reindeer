package titanium_reindeer.rendering;

class Renderer<S:IRenderState> implements IRenderer<S>
{
	public var state(get, null):S;
	public function get_state():S { return this.state; }

	public var position(get, null):Vector2;
	public function get_position():Vector2 { return this.position; }

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
