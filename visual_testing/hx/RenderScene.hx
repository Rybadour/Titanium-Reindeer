import js.Dom;

import titanium_reindeer.core.Scene;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.components.ICanvasRenderer;
import titanium_reindeer.components.Canvas2D;
import titanium_reindeer.components.CanvasRendererGroup;

class RenderScene extends Scene
{
	public var things(default, null):CanvasRendererGroup;

	public var pageCanvas(default, null):Canvas2D;

	public function new(provider:IHasIdProvider, parentDom:HtmlDom)
	{
		super(provider, "RenderScene");

		this.things = new CanvasRendererGroup(this, "things");
		this.pageCanvas = new Canvas2D("testCanvas", 1000, 1000);
		this.pageCanvas.appendToDom(parentDom);
	}

	private override function update(msTimeStep:Int):Void
	{
		super.update(msTimeStep);

		this.things.state.render(pageCanvas);
	}

	public function addRenderer(id:Int, renderer:ICanvasRenderer, layerName:String)
	{
		if (this.things.name == layerName)
			this.things.add(id, renderer);
	}
}
