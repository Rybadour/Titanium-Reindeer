package titanium_reindeer.spatial;

class CircleRegion extends Circle, implements IRegion
{
	public static function copy(cr:CircleRegion):CircleRegion
	{
		return new CircleRegion(cr.radius, cr.center);
	}

	public var center(getCenter, setCenter):Vector2;
	public function getCenter():Vector2 { return this.center; }
	public function setCenter(value:Vector2):Vector2
	{
		this.center = value;
		return this.center;
	}

	public function new(radius:Float, center:Vector2)
	{
		super(radius);

		if (center == null)
			this.center = new Vector2(0, 0);
		else
			this.center = center.getCopy();
	}

	public function getBoundingRectRegion():RectRegion
	{
		return new RectRegion(this.radius*2, this.radius*2, this.center);
	}

	public override function isPointInside(p:Vector2):Bool
	{
		return super.isPointInside(p.subtract(this.center));
	}
}
