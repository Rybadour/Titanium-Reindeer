package titanium_reindeer;

class RectRenderer extends StrokeFillRenderer
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

	public function new(width:Float, height:Float, layer:Int)
	{
		super(width, height, layer);

		this.width = width;
		this.height = height;
	}

	override public function render()
	{
		super.render();

		var x:Float = -width/2;
		var y:Float = -height/2;

		pen.fillRect(
			x,
			y,
			width,
			height
		);

		if (lineWidth > 0)
		{
			pen.strokeRect(
				x + lineWidth/2,
				y + lineWidth/2,
				width - lineWidth, 
				height - lineWidth
			);
		}
	}

	override public function identify():String
	{
		return super.identify() + "Rect();";
	}
}
