package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.TextRenderer;
import js.html.TextMetrics;

class UIText extends UIView 
{
	public var text:TextRenderer;

	public function new(text:String)
	{
		this.text = new TextRenderer(text);
		super(this.text);
	}

	private function calculateSize(canvas:Canvas2D):Void
	{
		canvas.save();
		this.text.state.apply(canvas);

		var measuredFont:TextMetrics = canvas.ctx.measureText(this.text.text); 
		var lineWidth = this.text.state.lineWidth;
		var fontSize = this.text.state.fontSize;

		this.width = measuredFont.width + (lineWidth > 0 ? lineWidth : 0);
		this.height = this.fontSize + (lineWidth > 0 ? lineWidth : 0);
		canvas.restore();
	}
}
