package titanium_reindeer.rendering;

class ColorStop
{
	public var color:Color;
	public var offset:Float;
	
	public function new(color:Color, offset:Float)
	{
		this.color = color;
		this.offset = offset;
	}

	public function identify():String
	{
		return "ColorStop("+color.identify()+","+offset+");";
	}
}
