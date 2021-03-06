package titanium_reindeer.spatial;

class Circle implements IShape
{
	public var radius:Float;

	public function new(radius:Float)
	{
		this.radius = radius;
	}

	public function getCopy():Circle
	{
		return new Circle(this.radius);
	}

	public function getBoundingRect():Rect
	{
		return new Rect(this.radius*2, this.radius*2);
	}

	public function intersectsPoint(p:Vector2):Bool
	{
		return this.radius >= p.getMagnitude();
	}

	public function getArea():Float
	{
		return Math.PI * this.radius*this.radius;
	}
}
