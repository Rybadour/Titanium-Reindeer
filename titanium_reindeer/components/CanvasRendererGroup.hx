package titanium_reindeer.components;

import titanium_reindeer.core.IGroup;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IdProvider;

class CanvasRendererGroup implements IGroup<ICanvasRenderer>, implements ICanvasRenderer
{
	private var hasProvider:IHasIdProvider;

	public var id(default, null):Int;
	public var idProvider(default, null):IdProvider;
	public var name(default, null):String;

	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.state; }

	private var minBounds:Rect;
	public var boundingShape(getBoundingShape, null):IShape;
	public function getBoundingShape():IShape
	{
		return Rect.copy(this.minBounds);
	}

	private var watchedCenter:Watcher<Vector2>;
	public var worldCenter(getWorldCenter, setWorldCenter):Vector2;
	public function getWorldCenter():Vector2
	{
		return this.watchedCenter.value;
	}
	public function setWorldCenter(value:Vector2):Vector2
	{
		this.watchedCenter.value = value;
		return this.worldCenter;
	}

	private var canvas(default, null):Canvas2D;
	private var renderers:IntHash<ICanvasRenderer>;

	public function new(provider:IHasIdProvider, name:String)
	{
		this.hasProvider = provider;
		this.id = this.hasProvider.idProvider.requestId();
		this.idProvider = new IdProvider();
		this.name = name;

		this.minBounds = new Rect(0, 0);

		this.state = new CanvasRenderState(this.render);
		this.canvas = new Canvas2D(name+"_canvas", 0, 0);

		this.renderers = new IntHash();
	}
	
	private function expandBounds(newShape:IShape):Void
	{
		var newBounds:Rect = newShape.getBoundingRect();
		if (this.minBounds.width == 0 && this.minBounds.height == 0)
			this.minBounds = newBounds;
		else
		{
			//this.minBounds = Rect.expandToCover(this.minBounds, newBounds);
			this.minBounds.width = Math.max(this.minBounds.width, newBounds.width);
			this.minBounds.height = Math.max(this.minBounds.height, newBounds.height);
		}

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
		this.expandBounds(renderer.boundingShape);
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

		for (renderer in this.renderers)
			renderer.state.render(this.canvas);

		//canvas.ctx.drawImage(this.canvas.canvas, -this.minBounds.width/2, -this.minBounds.height/2);
		canvas.ctx.drawImage(this.canvas.canvas, 0, 0);
	}
}
