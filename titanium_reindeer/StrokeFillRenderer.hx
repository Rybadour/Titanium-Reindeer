package titanium_reindeer;

import js.Dom;

enum LineCapType
{
	Butt; Round; Square;
}

enum LineJoinType
{
	Round; Bevel; Miter;
}

enum FillTypes
{
	Gradient; Pattern; ColorFill;
}

enum StrokeTypes
{
	Gradient; StrokeColor;
}

class StrokeFillRenderer extends RendererComponent
{
	private var fillStyle:Dynamic;
	private var currentFill:FillTypes;

	public var fillColor(default, setFill):Color;
	private function setFill(value:Color):Color
	{
		if (value != null)
		{
			currentFill = FillTypes.ColorFill;
			if (fillStyle != value.rgba)
			{
				fillColor = value;
				fillStyle = value.rgba;
				this.timeForRedraw = true;
			}
		}

		return value;
	}

	public var fillGradient(default, setFillGradient):LinearGradient;
	private function setFillGradient(value:LinearGradient):LinearGradient
	{
		if (value != null)
		{
			fillGradient = value;
			currentFill = FillTypes.Gradient; 
			if (pen != null && fillStyle != value.getStyle(pen))
			{
				fillStyle = value.getStyle(pen);
				this.timeForRedraw = true;
			}
		}

		return value;
	}

	public var fillPattern(default, setFillPattern):Pattern;
	private function setFillPattern(value:Pattern):Pattern
	{
		if (value != null)
		{
			fillPattern = value;
			if (value.imageSource.isLoaded)
			{
				currentFill = FillTypes.Pattern;
				if (pen != null && fillStyle != value.getStyle(pen))
				{
					fillStyle = value.getStyle(pen);
					this.timeForRedraw = true;
				}
			}
			else
			{
				value.imageSource.registerLoadEvent(fillPatternImageLoaded);
			}
		}

		return value;
	}
	
	private var strokeStyle:Dynamic;
	private var currentStroke:StrokeTypes;

	public var strokeColor(default, setStrokeColor):Color;
	private function setStrokeColor(value:Color):Color
	{
		if (value != null)
		{
			strokeColor = value;
			currentStroke = StrokeTypes.StrokeColor;
			if (strokeStyle != value.rgba)
			{
				strokeStyle = strokeColor.rgba;
				this.timeForRedraw = true;
			}
		}

		return value;
	}

	public var strokeGradient(default, setStrokeGradient):LinearGradient;
	private function setStrokeGradient(value:LinearGradient):LinearGradient
	{
		if (value != null)
		{
			strokeGradient = value;
			currentStroke = StrokeTypes.Gradient; 
			if (pen != null && strokeStyle != value.getStyle(pen))
			{
				strokeStyle = value.getStyle(pen);
				this.timeForRedraw = true;
			}
		}

		return value;
	}

	public var lineWidth(default, setLineWidth):Int;
	private function setLineWidth(value:Int):Int
	{
		if (value != lineWidth)
		{
			lineWidth = value;
			this.timeForRedraw = true;
		}

		return value;
	}

	public var lineCap(default, setLineCap):LineCapType;
	private function setLineCap(value:LineCapType):LineCapType
	{
		if (value != lineCap)
		{
			lineCap = value;
			this.timeForRedraw = true;
		}

		return value;
	}

	public var lineJoin(default, setLineJoin):LineJoinType;
	private function setLineJoin(value:LineJoinType):LineJoinType
	{
		if (value != lineJoin)
		{
			lineJoin = value;
			this.timeForRedraw = true;
		}

		return value;
	}

	public var miterLimit(default, setMiterLimit):Float;
	private function setMiterLimit(value:Float):Float
	{
		if (value != miterLimit)
		{
			miterLimit = value;
			this.timeForRedraw = true;
		}

		return value;
	}

	public function new(width:Float, height:Float, layer:Int)
	{
		super(width, height, layer);

		this.fillColor = Color.White;
		this.strokeColor = Color.Black;
		this.lineWidth = 0;
		this.lineCap = LineCapType.Butt;
		this.lineJoin = LineJoinType.Miter;
		this.miterLimit = 10.0;
	}

	override public function initialize():Void
	{
		super.initialize();

		// Pen Ready now, so we can initialize a fill if it needed a pen
		switch (currentFill)
		{
			case FillTypes.Gradient:
				fillStyle = fillGradient.getStyle(pen);
				this.timeForRedraw = true;
				
			case FillTypes.Pattern:
				if (fillStyle != fillPattern.getStyle(pen))
				{
					fillStyle = fillPattern.getStyle(pen);
					this.timeForRedraw = true;
				}
				
			case FillTypes.ColorFill:
				// Nothing (this fill does not require the pen)
		}

		switch (currentStroke)
		{
			case StrokeTypes.Gradient:
				strokeStyle = strokeGradient.getStyle(pen);
				this.timeForRedraw = true;
				
			case StrokeTypes.StrokeColor:
				// Nothing, this stroke didn't need the pen on setting
		}
	}

	private function fillPatternImageLoaded(event:Event):Void
	{
		currentFill = FillTypes.Pattern;
		if (pen != null && fillStyle != fillPattern.getStyle(pen))
		{
			fillStyle = fillPattern.getStyle(pen);
			this.timeForRedraw = true;
		}
	}

	override public function preRender():Void
	{
		super.preRender();

		pen.fillStyle = fillStyle;
		pen.strokeStyle = strokeStyle;
		pen.lineWidth = lineWidth;
		pen.miterLimit = miterLimit;

		switch (lineCap)
		{
			case LineCapType.Butt:
				pen.lineCap = "butt";

			case LineCapType.Round:
				pen.lineCap = "round";

			case LineCapType.Square:
				pen.lineCap = "square";
		}

		switch (lineJoin)
		{
			case LineJoinType.Round:
				pen.lineJoin = "round";

			case LineJoinType.Bevel:
				pen.lineJoin = "bevel";

			case LineJoinType.Miter:
				pen.lineJoin = "miter";
		}
	}

	override public function identify():String
	{
		var identifier:String = "StrokeFill(";
		switch (currentFill)
		{
			case FillTypes.Gradient:
				identifier += fillGradient.identify()+",";

			case FillTypes.Pattern:
				identifier += fillPattern.identify()+",";

			case FillTypes.ColorFill:
				identifier += fillColor.identify()+",";
		}
		switch (currentStroke)
		{
			case StrokeTypes.Gradient:
				identifier += strokeGradient.identify()+",";

			case StrokeTypes.StrokeColor:
				identifier += strokeColor.identify()+",";
		}
		identifier += lineWidth+",";
		identifier += Type.enumConstructor(lineCap)+",";
		identifier += Type.enumConstructor(lineJoin)+",";
		identifier += miterLimit+",";
		identifier += ");";

		return super.identify() + identifier;
	}

	override public function destroy():Void
	{
		super.destroy();

		fillStyle = null;
		fillColor = null;
		fillGradient = null;
		fillPattern = null;

		strokeColor = null;
		strokeGradient = null;
	}
}
