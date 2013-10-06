package titanium_reindeer.rendering;

class ParallaxRendererList<S:IRenderState, R:IRenderer> extends Renderer<S>
{
	private var parallaxRatios:Map<Int, Float>;
	private var layers:Array<R>;

	public var offset:Vector2;
	public var rule:Int -> R -> Vector2 -> Canvas2D -> Void;

	public function new(s:S, ?rule:Int -> R -> Vector2 -> Canvas2D -> Void)
	{
		super(s);

		this.parallaxRatios = new Map();
		this.layers = new Array();

		this.offset = new Vector2(0, 0);
		if (rule == null)
		{
			this.rule = function (i:Int, r:R, offset:Vector2, canvas:Canvas2D) {
				canvas.translate(offset);
			};
		}
		else
			this.rule = rule;
	}

	public function setParallax(i:Int, value:Float):Void
	{
		this.parallaxRatios.set(i, value);
	}

	public function addLayer(renderer:R, parallaxRatio:Float):Void
	{
		this.layers.push(renderer);
		this.setParallax(this.layers.length-1, parallaxRatio);
	}

	private override function _render(canvas:Canvas2D):Void
	{
		if (this.rule == null)
			return;
			
		var i = 0;
		for (layer in this.layers)
		{
			var ratio:Float = 1;
			if (this.parallaxRatios.exists(i))
			{
				ratio = this.parallaxRatios.get(i);
			}
			this.rule(i, layer, offset.getExtend(ratio), canvas);
			layer.render(canvas);
		}
	}
}
