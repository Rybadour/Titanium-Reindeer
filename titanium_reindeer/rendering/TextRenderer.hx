package titanium_reindeer.rendering;

class TextRenderer extends Renderer<TextState>
{
	public var text:String;

	public function new(text:String, state:TextState)
	{
		super(state);

		this.text = text;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		super._render(canvas);

		canvas.renderText(this.text);
	}
}
