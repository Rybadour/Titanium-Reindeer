package titanium_reindeer.rendering;

interface ICanvasRenderer<S:IRenderState>
{
	public var state(getState, null):S;
	public var position(getPosition, null):Vector2;

	public function render(canvas:Canvas2D):Void;
}
