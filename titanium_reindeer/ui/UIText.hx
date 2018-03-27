package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.TextRenderer;
import titanium_reindeer.rendering.TextState;
import js.html.TextMetrics;

class UIText extends UIElement 
{
	private var text:TextRenderer;
	private var needsCalculation:Bool;

	public function new(text:String, state:TextState)
	{
		super(0, 0);
		this.updateText(text, state);
	}

	public function updateText(text:String, ?state:TextState = null)
	{
		if (state == null)
		{
			state = this.text.state;
		}
		this.text = new TextRenderer(text, state);
		this.needsCalculation = true;
	}

	private override function preRender(canvas:Canvas2D):Void
	{
		if (this.needsCalculation)
			this.calculateSize(canvas);

		super.preRender(canvas);
	}

	private override function _render(canvas:Canvas2D):Void
	{
		canvas.save();
		canvas.translatef(0, this.height);
		this.text.render(canvas);
		canvas.restore();
	}

	private function calculateSize(canvas:Canvas2D):Void
	{
		canvas.save();
		this.text.state.apply(canvas);

		var measuredFont:TextMetrics = canvas.ctx.measureText(this.text.text); 
		var lineWidth = this.text.state.lineWidth;
		var fontSize = this.text.state.fontSize;

		this.width = Math.round(measuredFont.width + (lineWidth > 0 ? lineWidth : 0));
		this.height = fontSize + (lineWidth > 0 ? lineWidth : 0);
		canvas.restore();

		this.needsCalculation = false;
	}
}
