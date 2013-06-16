import js.Dom;

import titanium_reindeer.core.Scene;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.components.ICanvasRenderer;
import titanium_reindeer.components.Canvas2D;
import titanium_reindeer.components.CanvasRendererGroup;

class RenderScene extends Scene
{
	public var paddles(default, null):CanvasRendererGroup;
	public var balls(default, null):CanvasRendererGroup;
	public var bg(default, null):CanvasRendererGroup;

	public var pageCanvas(default, null):Canvas2D;

	public function new(provider:IHasIdProvider, parentDom:HtmlDom)
	{
		super(provider, "RenderScene");

		this.paddles = new CanvasRendererGroup(this, "paddles");
		this.balls = new CanvasRendererGroup(this, "balls");
		this.bg = new CanvasRendererGroup(this, "bg");

		this.pageCanvas = new Canvas2D("testCanvas", 400, 400);
		this.pageCanvas.appendToDom(parentDom);
	}

	private override function update(msTimeStep:Int):Void
	{
		super.update(msTimeStep);

		this.pageCanvas.clear();
		this.bg.state.render(this.pageCanvas);
		this.balls.state.render(this.pageCanvas);
		this.paddles.state.render(this.pageCanvas);
	}

	public function addRenderer(id:Int, renderer:ICanvasRenderer, layerName:String)
	{
		if (this.paddles.name == layerName)
			this.paddles.add(id, renderer);

		if (this.balls.name == layerName)
			this.balls.add(id, renderer);

		if (this.bg.name == layerName)
			this.bg.add(id, renderer);
	}
}
