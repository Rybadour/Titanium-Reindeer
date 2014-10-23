package titanium_reindeer.rendering;

import titanium_reindeer.util.Utility;
import titanium_reindeer.spatial.Vector2;

enum RepeatFillMethod
{
	Horizontal;
	Vertical;
	Both;
}

class RepeatFillRenderer extends Renderer<RenderState>
{
	/**
	 * The internal offset within the view port.
	 */
	public var offset:Vector2;

	/**
	 * The view port width. Rendering will only be done within this width starting at the x offset.
	 */
	public var fillWidth:Int;

	/**
	 * The view port width. Rendering will only be done within this width starting at the x offset.
	 */
	public var fillHeight:Int;

	/**
	 * The expected width of one renderer. 
	 * Defaults to fillWidth.
	 */
	public var sourceWidth:Int;

	/**
	 * The expected height of one renderer. 
	 * Defaults to fillHeight.
	 */
	public var sourceHeight:Int;
	
	/**
	 * The 
	 */
	public var method:RepeatFillMethod;

	public function new(width:Int, height:Int, method:RepeatFillMethod, ?sWidth:Int, ?sHeight:Int)
	{
		super(new RenderState());

		this.offset = new Vector2(0, 0);
		this.fillWidth = width;
		this.fillHeight = height;
		this.method = method;
		this.sourceWidth = (sWidth == null) ? width : sWidth;
		this.sourceHeight = (sHeight == null) ? height : sHeight;
	}

	private function renderTile(x:Int, y:Int, canvas:Canvas2D):Void
	{
	}

	private override function _render(canvas:Canvas2D):Void
	{
		var xRepeat = method == Horizontal || method == Both;
		var yRepeat = method == Vertical || method == Both;

		var xCount = xRepeat ? Math.ceil(this.fillWidth/this.sourceWidth)+1 : 1;
		var yCount = yRepeat ? Math.ceil(this.fillHeight/this.sourceHeight)+1 : 1;
		var left = this.offset.x;
		if (xRepeat)
		{
			left %= this.sourceWidth;
			if (this.offset.x > 0)
				left -= this.sourceWidth;
		}

		var startTop = this.offset.y;
		if (yRepeat)
		{
			startTop %= this.sourceHeight;
			if (this.offset.y > 0)
				startTop -= this.sourceHeight;
		}

		for (i in 0...xCount)
		{
			var top = startTop;
			for (j in 0...yCount)
			{
				canvas.ctx.save();
				canvas.ctx.translate(left, top);
				this.renderTile(i, j, canvas);
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
