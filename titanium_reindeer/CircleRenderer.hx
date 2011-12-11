package titanium_reindeer;

class CircleRenderer extends StrokeFillRenderer
{
	public var radius(default, setRadius):Float;
	private function setRadius(value:Float):Float
	{
		if (this.radius != value) 
		{
			this.radius = value;
			this.initialDrawnWidth = value*2;
			this.initialDrawnWidth = value*2;
		}

		return this.radius;
	}

	public function new(radius:Float, layer:Int)
	{
		super(radius*2, radius*2, layer);

		this.radius = radius;
	}

	override public function render()
	{	
		super.render();

		pen.beginPath();
		pen.arc(0, 0, this.radius, 0, Math.PI*2, false);
		pen.fill(); 
		pen.closePath();
	
		if (lineWidth > 0)
		{
			pen.beginPath();
			pen.arc(0, 0, this.radius - lineWidth/2, 0, Math.PI*2, false);
			pen.stroke();
			pen.closePath();
		}
	}

	override public function identify():String
	{
		return super.identify() + "Circle("+radius+");";
	}
}
