package titanium_reindeer.rendering;

class RendererList<S:IRenderState> extends Renderer<S>
{
	private var renderers:Array<IRenderer>;

	public function new(s:S)
	{
		super(s);

		this.renderers = new Array();
	}
	
	public function get(i:Int):IRenderer
	{
		return this.renderers[i];
	}

	public function insert(i:Int, renderer:IRenderer):Void
	{
		if (renderer == null)
			return;

		this.renderers.insert(i, renderer);
	}

	public function push(renderer:IRenderer):Void
	{
		this.renderers.push(renderer);
	}

	public function remove(i:Int):Void
	{
		this.renderers.splice(i, 1);
	}

	private override function _render(canvas:Canvas2D):Void
	{
		for (renderer in this.renderers)
			renderer.render(canvas);
	}
}
