package titanium_reindeer.rendering;

import titanium_reindeer.spatial.Vector2;

enum RepeatFillMethod
{
	Horizontal;
	Vertical;
	Both;
}

class RepeatFillRenderer extends Renderer<RenderState>
{
	public var offset:Vector2;
	public var renderer:IRenderer;
	public var fillWidth:Int;
	public var fillHeight:Int;
	public var method:RepeatFillMethod;
	public var sourceWidth:Int;
	public var sourceHeight:Int;

	public function new(r:IRenderer, width:Int, height:Int, method:RepeatFillMethod, ?sWidth:Int, ?sHeight:Int)
	{
		super(new RenderState());

		this.offset = new Vector2(0, 0);
		this.renderer = r;
		this.fillWidth = width;
		this.fillHeight = height;
		this.method = method;
		this.sourceWidth = (sWidth == null) ? width : sWidth;
		this.sourceHeight = (sHeight == null) ? height : sHeight;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		if (this.renderer == null)
			return;

		var temp = new Canvas2D("temp", this.sourceWidth, this.sourceHeight);
		this.renderer.render(temp);

		var xRepeat = method == Horizontal || method == Both;
		var yRepeat = method == Vertical || method == Both;

		var xCount = xRepeat ? Math.ceil(this.fillWidth/this.sourceWidth)+1 : 1;
		var yCount = yRepeat ? Math.ceil(this.fillHeight/this.sourceHeight)+1 : 1;
		var left = this.offset.x;
		if (xRepeat)
		{
			left = (this.offset.x % this.sourceWidth);
			if (this.offset.x > 0)
				left = (this.offset.x % this.sourceWidth) - this.sourceWidth;
		}

		var startTop = this.offset.y;
		if (yRepeat)
		{
			startTop = (this.offset.y % this.sourceHeight);
			if (this.offset.y > 0)
				startTop = (this.offset.y % this.sourceHeight) - this.sourceHeight;
		}

		for (i in 0...xCount)
		{
			var top = startTop;
			for (j in 0...yCount)
			{
				canvas.ctx.save();
				canvas.ctx.translate(left, top);
				canvas.renderCanvas(temp);
				canvas.ctx.restore();

				top += this.sourceHeight;
			}
			left += this.sourceWidth;
		}
	}

	public function resize(width:Int, height:Int)
	{
		// Update source width and height if mimic to fill
		if (this.sourceWidth == this.fillWidth)
			this.sourceWidth = width;
		if (this.sourceHeight == this.fillHeight)
			this.sourceHeight = height;

		this.fillWidth = width;
		this.fillHeight = height;
	}
}
