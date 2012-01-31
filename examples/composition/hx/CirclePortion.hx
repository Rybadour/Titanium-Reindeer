import titanium_reindeer.StrokeFillRenderer;

class CirclePortion extends StrokeFillRenderer
{
	public var radius(default, null):Float;
	public var startRads(default, null):Float;
	public var endRads(default, null):Float;

	public function new(radius:Float, startRads:Float, endRads:Float, layer:Int)
	{
		super(radius*2, radius*2, layer);

		this.radius = radius;
		this.startRads = startRads;
		this.endRads = endRads;
	}

	public override function render():Void
	{
		super.render();

		pen.beginPath();
		pen.arc(0, 0, this.radius, this.startRads, this.endRads);
		pen.fill(); 
		pen.closePath();
	
		if (lineWidth > 0)
		{
			pen.beginPath();
			pen.arc(0, 0, this.radius - lineWidth/2, this.startRads, this.endRads);
			pen.stroke();
			pen.closePath();
		}

	}
}
