package titanium_reindeer.spatial;

class Rect implements IShape
{
	public static function copy(r:Rect):Rect
	{
		return new Rect(r.width, r.height);
	}

	public var width(default, setWidth):Float;
	private function setWidth(value:Float):Float
	{
		this.width = value;
		return this.width;
	}
	public var height(default, setHeight):Float;
	private function setHeight(value:Float):Float
	{
		this.height = value;
		return this.height;
	}

	public function new(width:Float, height:Float)
	{
		this.width = width;
		this.height = height;
	}

	public function getBoundingRect():Rect
	{
		return Rect.copy(this);
	}

	public function getArea():Float
	{
		return this.width * this.height;
	}
}
