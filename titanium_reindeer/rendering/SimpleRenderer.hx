package titanium_reindeer.rendering;

class SimpleRenderer implements IRenderer
{
	public var renderFunc:Canvas2D -> Void;

	public function new(renderFunc:Canvas2D -> Void)
	{
		this.renderFunc = renderFunc;
	}

	public function render(canvas:Canvas2D)
	{
		this.renderFunc(canvas);
	}
}
