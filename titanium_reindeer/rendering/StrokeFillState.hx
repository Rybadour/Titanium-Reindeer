package titanium_reindeer.rendering;

import js.html.CanvasPattern;
import titanium_reindeer.Enums;

class StrokeFillState extends RenderState
{
	private var currentFill:FillTypes;

	public var fillColor(default, set):Color;
	private function set_fillColor(value:Color):Color
	{
		if (value != null)
		{
			this.currentFill = FillTypes.FillColor;
			this.fillColor = value;
		}

		return value;
	}

	public var fillGradient(default, set):LinearGradient;
	private function set_fillGradient(value:LinearGradient):LinearGradient
	{
		if (value != null)
		{
			this.fillGradient = value;
			this.currentFill = FillTypes.Gradient; 
		}

		return value;
	}

	public var fillPattern(default, set):CanvasPattern;
	private function set_fillPattern(value:CanvasPattern):CanvasPattern
	{
		if (value != null)
		{
			this.fillPattern = value;
			this.currentFill = FillTypes.Pattern;

			/* *
			if (!value.imageSource.isLoaded)
			{
				value.imageSource.registerLoadEvent(this.fillPatternImageLoaded);
			}
			/* */
		}

		return value;
	}

	private var currentStroke:StrokeTypes;

	public var strokeColor(default, set):Color;
	private function set_strokeColor(value:Color):Color
	{
		if (value != null)
		{
			this.strokeColor = value;
			this.currentStroke = StrokeTypes.StrokeColor;
		}

		return value;
	}

	public var strokeGradient(default, set):LinearGradient;
	private function set_strokeGradient(value:LinearGradient):LinearGradient
	{
		if (value != null)
		{
			this.strokeGradient = value;
			this.currentStroke = StrokeTypes.Gradient; 
		}

		return value;
	}

	public var lineWidth(default, set):Int;
	private function set_lineWidth(value:Int):Int
	{
		if (value != lineWidth)
		{
			this.lineWidth = value;
		}

		return value;
	}

	public var lineCap(default, set):LineCapType;
	private function set_lineCap(value:LineCapType):LineCapType
	{
		if (value != lineCap)
		{
			this.lineCap = value;
		}

		return value;
	}

	public var lineJoin(default, set):LineJoinType;
	private function set_lineJoin(value:LineJoinType):LineJoinType
	{
		if (value != lineJoin)
		{
			this.lineJoin = value;
		}

		return value;
	}

	public var miterLimit(default, set):Float;
	private function set_miterLimit(value:Float):Float
	{
		if (value != miterLimit)
		{
			this.miterLimit = value;
		}

		return value;
	}

	public function new()
	{
		super();

		this.fillColor = Color.White;
		this.strokeColor = Color.Black;
		this.lineWidth = 0;
		this.lineCap = LineCapType.Butt;
		this.lineJoin = LineJoinType.Miter;
		this.miterLimit = 10.0;
	}

	public override function apply(canvas:Canvas2D):Void
	{
		super.apply(canvas);

		canvas.ctx.lineWidth = this.lineWidth;
		canvas.ctx.miterLimit = this.miterLimit;

		var cap:String;
		switch (this.lineCap)
		{
			case LineCapType.Butt:
				cap = "butt";

			case LineCapType.Round:
				cap = "round";

			case LineCapType.Square:
				cap = "square";
		}
		canvas.ctx.lineCap = cap;

		var join:String;
		switch (this.lineJoin)
		{
			case LineJoinType.Round:
				join = "round";

			case LineJoinType.Bevel:
				join = "bevel";

			case LineJoinType.Miter:
				join = "miter";
		}
		canvas.ctx.lineJoin = join;

		var style:Dynamic = null;
		switch (this.currentFill)
		{
			case Gradient:
				style = this.fillGradient.getStyle(canvas);
			case Pattern:
				style = this.fillPattern;
			case FillColor:
				style = this.fillColor.rgba;
		}
		canvas.ctx.fillStyle = style;
		
		switch (this.currentStroke)
		{
			case Gradient:
				style = this.strokeGradient.getStyle(canvas);
			case StrokeColor:
				style = this.strokeColor.rgba;
		}
		canvas.ctx.strokeStyle = style;
	}
}
