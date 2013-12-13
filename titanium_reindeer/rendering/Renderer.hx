package titanium_reindeer.rendering;

class Renderer<S:IRenderState> implements IRenderer
{
	public var state:S;

	public function new(state:S)
	{
		this.state = state;
	}

	public function render(canvas:Canvas2D):Void
	{
		canvas.ctx.save();
		this.state.apply(canvas);
		this._render(canvas);
		canvas.ctx.restore();
	}

	private function _render(canvas:Canvas2D):Void { }
}
