package titanium_reindeer.rendering;

interface ICanvasRenderer
{
	public var state(getState, null):IRenderState;
	public var position(getPosition, null):Vector2;

	public function render(canvas:Canvas2D):Void;
}
