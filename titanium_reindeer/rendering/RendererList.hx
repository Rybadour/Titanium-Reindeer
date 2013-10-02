package titanium_reindeer.rendering;

typedef ReadOnlyState = {
	public function apply(canvas:Canvas2D):Void;
};

class RendererList<S:IRenderState> extends Renderer<S>
{
	private var renderers:Array<ICanvasRenderer<ReadOnlyState>>;

	public function new(?renderers:Array<ICanvasRenderer<ReadOnlyState>>)
	{
		super(new S());

		this.renderers = (renderers == null) ? new Array() : renderers.copy();
	}
	
	public function get(i:Int):ICanvasRenderer<ReadOnlyState>
	{
		return this.renderers[i];
	}

	public function insert(i:Int, renderer:ICanvasRenderer<ReadOnlyState>):Void
	{
		if (renderer == null)
			return;

		this.renderers.insert(i, renderer);
	}

	public function remove(i:Int):Void
	{
		this.renderers.splice(i, 1);
	}

	private function _render(canvas:Canvas2D):Void
	{
		for (renderer in this.renderers)
			renderer.render(canvas);
	}
}
