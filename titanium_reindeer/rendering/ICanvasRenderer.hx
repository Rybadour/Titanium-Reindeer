package titanium_reindeer.rendering;

interface ICanvasRenderer<S:IRenderState>
{
	public var state(get, null):S;
	public var position(get, null):Vector2;

	public function render(canvas:Canvas2D):Void;
}
