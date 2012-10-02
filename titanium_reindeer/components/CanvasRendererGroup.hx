package titanium_reindeer.components;

import titanium_reindeer.core.IGroup;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IdProvider;
import titanium_reindeer.core.IRegion;
import titanium_reindeer.core.RectRegion;

class CanvasRendererGroup implements IGroup<ICanvasRenderer>, implements ICanvasRenderer
{
	private var hasProvider:IHasIdProvider;

	public var id(default, null):Int;
	public var idProvider(default, null):IdProvider;
	public var name(default, null):String;

	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.state; }

	private var minBounds:RectRegion;

	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion
	{
		return new RectRegion(this.minBounds.width, this.minBounds.height, this.state.watchedPosition.value);
	}

	private var canvas(default, null):Canvas2D;
	private var renderers:IntHash<ICanvasRenderer>;

	public function new(provider:IHasIdProvider, name:String)
	{
		this.hasProvider = provider;
		this.id = this.hasProvider.idProvider.requestId();
		this.idProvider = new IdProvider();
		this.name = name;

		this.minBounds = new RectRegion(0, 0, new Vector2(0, 0));

		this.state = new CanvasRenderState(this.render);
		this.canvas = new Canvas2D(name+"_canvas", 0, 0);

		this.renderers = new IntHash();
	}
	
	private function expandBounds(newBounds:RectRegion):Void
	{
		if (this.minBounds.width == 0 && this.minBounds.height == 0)
			this.minBounds = RectRegion.copy(newBounds);
		else
			this.minBounds = RectRegion.expandToCover(this.minBounds, newBounds);

		this.canvas.width = this.minBounds.width;
		this.canvas.height = this.minBounds.height;
	}

	// As IGroup
	public function get(id:Int):ICanvasRenderer
	{
		if ( !this.renderers.exists(id) )
			return null;

		return this.renderers.get(id);
	}

	public function add(id:Int, renderer:ICanvasRenderer):Void
	{
		if (renderer == null)
			return;

		this.renderers.set(id, renderer);
		this.expandBounds(renderer.boundingRegion.getBoundingRectRegion());
	}

	public function remove(id:Int):Void
	{
		if (!this.renderers.exists(id))
			return;

		this.renderers.remove(id);
	}

	// As ICanvasRenderer
	private function render(canvas:Canvas2D):Void
	{
		this.canvas.clear();

		// Each renderer is drawn in the context of the render group
		this.canvas.ctx.save();
		this.canvas.ctx.translate(-this.minBounds.left, -this.minBounds.top);

		for (renderer in this.renderers)
			renderer.state.render(this.canvas);

		this.canvas.ctx.restore();

		// The canvas is then drawn		
		canvas.ctx.drawImage(this.canvas.canvas, -this.minBounds.width/2, -this.minBounds.height/2);
	}
}
