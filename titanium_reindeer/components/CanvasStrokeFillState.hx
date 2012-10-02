package titanium_reindeer.components;

import js.Dom;

import titanium_reindeer.Enums;
import titanium_reindeer.LinearGradient;
import titanium_reindeer.Pattern;

class CanvasStrokeFillState extends CanvasRenderState
{
	private var lastRenderedCanvas:Canvas2D;

	private var fillStyle:Dynamic;
	private var currentFill:FillTypes;
	private var isFillUnstyled:Bool;

	public var fillColor(default, setFill):Color;
	private function setFill(value:Color):Color
	{
		if (value != null)
		{
			this.currentFill = FillTypes.ColorFill;
			if (this.fillStyle != value.rgba)
			{
				this.fillColor = value;
				this.fillStyle = value.rgba;
			}
		}

		return value;
	}

	public var fillGradient(default, setFillGradient):LinearGradient;
	private function setFillGradient(value:LinearGradient):LinearGradient
	{
		if (value != null)
		{
			this.fillGradient = value;
			this.currentFill = FillTypes.Gradient; 
			
			if (this.lastRenderedCanvas != null)
			{
				var style = value.getStyle(this.lastRenderedCanvas);
				if (this.fillStyle != style)
				{
					this.fillStyle = style;
				}
			}
			else
				this.isFillUnstyled = true;
		}

		return value;
	}

	public var fillPattern(default, setFillPattern):Pattern;
	private function setFillPattern(value:Pattern):Pattern
	{
		if (value != null)
		{
			this.fillPattern = value;
			this.currentFill = FillTypes.Pattern;

			if (value.imageSource.isLoaded)
			{
				if (this.lastRenderedCanvas != null)
				{
					var style = value.getStyle(this.lastRenderedCanvas);
					if (this.fillStyle != style)
					{
						this.fillStyle = style;
					}
				}
				else
					this.isFillUnstyled = true;
			}
			else
			{
				value.imageSource.registerLoadEvent(this.fillPatternImageLoaded);
			}
		}

		return value;
	}
	
	private var strokeStyle:Dynamic;
	private var currentStroke:StrokeTypes;
	private var isStrokeUnstyled:Bool;

	public var strokeColor(default, setStrokeColor):Color;
	private function setStrokeColor(value:Color):Color
	{
		if (value != null)
		{
			this.strokeColor = value;
			this.currentStroke = StrokeTypes.StrokeColor;

			if (strokeStyle != value.rgba)
			{
				this.strokeStyle = strokeColor.rgba;
			}
		}

		return value;
	}

	public var strokeGradient(default, setStrokeGradient):LinearGradient;
	private function setStrokeGradient(value:LinearGradient):LinearGradient
	{
		if (value != null)
		{
			this.strokeGradient = value;
			this.currentStroke = StrokeTypes.Gradient; 

			if (this.lastRenderedCanvas != null)
			{
				var style = value.getStyle(this.lastRenderedCanvas);
				if (this.strokeStyle != style)
				{
					this.strokeStyle = style;
				}
			}
		}

		return value;
	}

	public var lineWidth(default, setLineWidth):Int;
	private function setLineWidth(value:Int):Int
	{
		if (value != lineWidth)
		{
			this.lineWidth = value;
		}

		return value;
	}

	public var lineCap(default, setLineCap):LineCapType;
	private function setLineCap(value:LineCapType):LineCapType
	{
		if (value != lineCap)
		{
			this.lineCap = value;
		}

		return value;
	}

	public var lineJoin(default, setLineJoin):LineJoinType;
	private function setLineJoin(value:LineJoinType):LineJoinType
	{
		if (value != lineJoin)
		{
			this.lineJoin = value;
		}

		return value;
	}

	public var miterLimit(default, setMiterLimit):Float;
	private function setMiterLimit(value:Float):Float
	{
		if (value != miterLimit)
		{
			this.miterLimit = value;
		}

		return value;
	}

	public function new(renderFunc:Canvas2D -> Void)
	{
		super(renderFunc);

		this.isFillUnstyled = false;
		this.isStrokeUnstyled = false;
	}

	private function fillPatternImageLoaded(event:Event):Void
	{
		if (this.lastRenderedCanvas != null)
		{
			if (this.fillStyle != this.fillPattern.getStyle(this.lastRenderedCanvas))
			{
				this.fillStyle = fillPattern.getStyle(this.lastRenderedCanvas);
			}
		}
		else
			this.isFillUnstyled = true;
	}

	private override function preRender(canvas:Canvas2D):Void
	{
		this.lastRenderedCanvas = canvas;

		if (this.isFillUnstyled)
		{
			if (this.currentFill == FillTypes.Gradient)
				this.fillStyle = this.fillGradient.getStyle(this.lastRenderedCanvas);
			else if (this.currentFill == FillTypes.Pattern)
				this.fillStyle = this.fillPattern.getStyle(this.lastRenderedCanvas);

			this.isFillUnstyled = false;
		}
		
		if (this.isStrokeUnstyled)
		{
			if (this.currentStroke == StrokeTypes.Gradient)
				this.strokeStyle = this.strokeGradient.getStyle(this.lastRenderedCanvas);

			this.isStrokeUnstyled = false;
		}
	}
}
