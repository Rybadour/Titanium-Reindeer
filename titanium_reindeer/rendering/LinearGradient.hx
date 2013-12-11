package titanium_reindeer.rendering;

class LinearGradient
{
	public var x0:Float;
	public var x1:Float;

	public var y0:Float;
	public var y1:Float;

	public var colorStops(default, null):List<ColorStop>;

	public function new(x0:Float, y0:Float, x1:Float, y1:Float, colorStops:Array<ColorStop>)
	{
		this.x0 = x0;
		this.y0 = y0;
		this.x1 = x1;
		this.y1 = y1;

		this.colorStops = new List();
		for (colorStop in colorStops)
		{
			this.colorStops.add(colorStop);
		}
	}

	public function addColorStop(colorStop:ColorStop):Void
	{
		colorStops.add(colorStop);
	}

	private function applyColorStops(gradient:Dynamic):Void
	{
		for (colorStop in colorStops)
		{
			gradient.addColorStop(colorStop.offset, colorStop.color.rgba);
		}
	}

	public function getStyle(pen:Dynamic):Dynamic
	{
		var gradient:Dynamic = pen.createLinearGradient(x0, y0, x1, y1);
		applyColorStops(gradient);
		return gradient;
	}

	public function identify():String
	{
		var identity:String = "Gradient("+x0+","+x1+","+y0+","+y1+",";
		for (colorStop in colorStops)
			identity += colorStop.identify()+",";
		return identity+");";
	}

	public function destroy():Void
	{
		this.colorStops.clear();
		this.colorStops = null;
	}
}
