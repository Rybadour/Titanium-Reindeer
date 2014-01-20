package titanium_reindeer.rendering;

import titanium_reindeer.spatial.Vector2;

class Shadow
{
	public var color(default, null):Color;
	public var offset(default, null):Vector2;
	public var blur(default, null):Float;

	public function new(color:Color, offset:Vector2, blur:Float)
	{
		this.color = color;
		this.offset = offset;
		this.blur = blur;
	}

	public function equal(other:Shadow):Bool
	{
		return color.equal(other.color) && offset.equal(other.offset) && blur == other.blur;
	}

	public function identify():String
	{
		return "Shadow("+color.identify()+","+offset.identify()+","+blur+");";
	}
}
