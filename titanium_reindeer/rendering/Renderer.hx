package titanium_reindeer.rendering;

class Renderer<S:IRenderState> implements IRenderer
{
	public var state:S;
	public var position:Vector2;

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
