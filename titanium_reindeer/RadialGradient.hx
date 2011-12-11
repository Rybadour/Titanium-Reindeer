package titanium_reindeer;

class RadialGradient extends LinearGradient
{
	public var r0;
	public var r1;

	public function new(x0:Float, y0:Float, r0:Float, x1:Float, y1:Float, r1:Float, colorStops:Array<ColorStop>)
	{
		super(x0, y0, x1, y1, colorStops);

		this.r0 = r0;
		this.r1 = r1;
	}

	public function getStyle(pen:Dynamic, offset:Vector2 = null):Dynamic
	{
		var gradient:Dynamic;
		if (offset == null)
		{
			gradient = pen.createRadialGradient(x0, y0, r0, x1, y1, r1);
		}
		else
		{
			gradient = pen.createLinearGradient(x0 + offset.x, y0 + offset.y, r0, x1 + offset.x, y1 + offset.y, r1);
		}
		applyColorStops(gradient);
		return gradient;
	}

	override public function identify():String
	{
		return super.identify()+";RadialGradient("+r0+","+r1+");";
	}
}
