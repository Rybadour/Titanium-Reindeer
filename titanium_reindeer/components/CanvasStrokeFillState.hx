package titanium_reindeer.components;

import titanium_reindeer.Enums;

class CanvasStrokeFillRenderState extends CanvasRenderState
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

	public function new(renderFunc:Canvas2D -> Void)
	{
		this.renderFunc = renderFunc;
	}

	private override function preRender(canvas:Canvas2D):Void
	{
	}

	public function render(canvas:Canvas2D):Void
	{
		this.preRender(canvas);
		this.renderFunc(canvas);
		this.postRender(canvas);
	}
}
