package titanium_reindeer.rendering;

class TextRenderer extends Renderer<TextState>
{
	public var text:String;

	public function new(text:String)
	{
		super(new TextState());

		this.text = text;
	}

	/* *
	private function recalculateSize():Void
	{
		if (pen != null)
		{
			setFontAttributes();

			var measuredFont:Dynamic = pen.measureText(text); 

			this.initialDrawnWidth = measuredFont.width + (lineWidth > 0 ? lineWidth : 0);
			this.initialDrawnHeight = this.fontSize + (lineWidth > 0 ? lineWidth : 0);

			this.timeForRedraw = true;
		}
	}
	/* */

	private override function _render(canvas:Canvas2D):Void
	{
		super._render(canvas);

		canvas.renderText(this.text);
	}
}
