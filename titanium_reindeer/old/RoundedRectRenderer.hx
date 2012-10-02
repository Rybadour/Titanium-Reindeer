package titanium_reindeer;

class RoundedRectRenderer extends StrokeFillRenderer
{
	public var width(default, setWidth):Float;
	private function setWidth(value:Float):Float
	{
		if (this.width != value)
		{
			this.initialDrawnWidth = value;
			this.width = value;
		}

		return this.width;
	}

	public var height(default, setHeight):Float;
	private function setHeight(value:Float):Float
	{
		if (this.height != value)
		{
			this.initialDrawnHeight = value;
			this.height = value;
		}

		return this.height;
	}

	public var cornerRadius(default, setCornerRadius):Float;
	private function setCornerRadius(value:Float):Float
	{
		if (this.cornerRadius != value)
		{
			value = Math.min(value, this.width/2);
			value = Math.min(value, this.height/2);

			this.cornerRadius = value;
			this.timeForRedraw = true;
		}

		return this.cornerRadius;
	}

	public function new(width:Float, height:Float, cornerRadius:Float, layer:Int)
	{
		super(width, height, layer);

		this.width = width;
		this.height = height;
		this.cornerRadius = cornerRadius;
	}

	override public function render()
	{
		super.render();

		this.createPath(this.width, this.height, 0);
		pen.fill();

		if (lineWidth > 0)
		{
			this.createPath(this.width - this.lineWidth, this.height - this.lineWidth, 3);
			pen.stroke();
		}
	}

	private function createPath(width:Float, height:Float, cornerNudge:Float):Void
	{
		var x:Float = -width/2;
		var y:Float = -height/2;

		var radius:Float = this.cornerRadius - cornerNudge;

		pen.beginPath();
		pen.moveTo(x + radius, y);
		pen.lineTo(x + width - radius, y);
		pen.quadraticCurveTo(x + width, y, x + width, y + radius);
		pen.lineTo(x + width, y + height - radius);
		pen.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
		pen.lineTo(x + radius, y + height);
		pen.quadraticCurveTo(x, y + height, x, y + height - radius);
		pen.lineTo(x, y + radius);
		pen.quadraticCurveTo(x, y, x + radius, y);
		pen.closePath();
	}

	override public function identify():String
	{
		return super.identify() + "Rect();";
	}
}
