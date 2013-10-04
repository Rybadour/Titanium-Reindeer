package titanium_reindeer.rendering;

class ParallaxRendererList<S:IRenderState> extends RendererList<S>
{
	public var offset:Vector2;
	private var parallaxRatios:Map<Int, Float>;

	public function new(s:S)
	{
		super(s);

		this.offset = new Vector2(0, 0);
		this.parallaxRatios = new Map();
	}

	public function setParallax(i:Int, value:Float):Void
	{
		this.parallaxRatios.set(i, value);
	}

	public function addLayer(renderer:IRenderer, parallaxRatio:Float):Void
	{
		this.push(renderer);
		this.setParallax(this.renderers.length-1, parallaxRatio);
	}

	private override function beforeRender(i:Int, renderer:IRenderer, canvas:Canvas2D):Void
	{
		var ratio:Float = 1;
		if (this.parallaxRatios.exists(i))
		{
			ratio = this.parallaxRatios.get(i);
		}
		canvas.translate(offset.getExtend(ratio));
	}
}
