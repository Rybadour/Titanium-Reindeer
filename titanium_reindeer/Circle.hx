package titanium_reindeer;

import titanium_reindeer.components.IShape;

class Circle implements IShape
{
	public static function isIntersecting(a:Circle, b:Circle):Bool
	{
		return a.radius + b.radius > Vector2.getDistance(a.center, b.center);
	}

	public var radius:Float;
	public var center(default, setCenter):Vector2;
	private function setCenter(value:Vector2):Vector2
	{
		if (value != null)
		{
			this.center = value;
		}
		return this.center;
	}

	public function new(radius:Float, center:Vector2)
	{
		this.radius = radius;
		this.center = new Vector2(0, 0);
		this.center = center;
	}

	public function getBoundingRect():Rect
	{
		return new Rect(this.center.x - this.radius, this.center.y - this.radius, this.radius*2, this.radius*2);
	}

	public function isPointInside(p:Vector2):Bool
	{
		return this.radius >= Vector2.getDistance(p, this.center);
	}
}
