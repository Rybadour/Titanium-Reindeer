package titanium_reindeer.core;

class Circle implements IShape
{
	public var radius:Float;

	public function new(radius:Float)
	{
		this.radius = radius;
	}

	public function isPointInside(point:Vector2):Bool
	{
		if (point == null)
			return false;

		return point.getMagnitude() <= this.radius;
	}
	
	public function getBoundingRect():Rect
	{
		return new Rect(radius*2, radius*2);
	}

	public function getArea():Float
	{
		return Math.PI * this.radius*this.radius;
	}
}
