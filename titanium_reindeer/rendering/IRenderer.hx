package titanium_reindeer.rendering;

// Note: Maybe remove the type param here and only have it in Renderer
interface IRenderer<S:IRenderState>
{
	public var state(get, null):S;
	public var position(get, null):Vector2;

	public function render(canvas:Canvas2D):Void;
}
