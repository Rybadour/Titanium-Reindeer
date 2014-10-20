package titanium_reindeer.rendering;

import titanium_reindeer.rendering.RepeatFillRenderer;

class StaticRepeatFillRenderer extends RepeatFillRenderer
{
	public var renderer:IRenderer;
	public var cached:Canvas2D;

	public function new(renderer:IRenderer, width:Int, height:Int, method:RepeatFillMethod, ?sWidth:Int, ?sHeight:Int)
	{
		super(width, height, method, sWidth, sHeight);

		this.renderer = renderer;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		this.cached = new Canvas2D('static_cache', this.sourceWidth, this.sourceHeight);
		this.renderer.render(this.cached);

		super._render(canvas);
	}

	private override function renderTile(x:Int, y:Int, canvas:Canvas2D):Void
	{
		return canvas.renderCanvas(this.cached);
	}
}
