package titanium_reindeer.spatial;

class Point2 implements IRegion
{
	public static function getDistance(a:Point2, b:Point2):Float
	{
		return Math.sqrt( (b.x-a.x)*(b.x-a.x) + (b.y-a.y)*(b.y-a.y) );
	}


	public var x:Float;
	public var y:Float;

	public function new(x, y)
	{
		this.x = x;
		this.y = y;
	}
	
	public function getCopy()
	{
		return new Point2(this.x, this.y);
	}

	public function add(b:Vector2)
	{
		if (b == null)
			return this.getCopy();

		return new Point2(this.x + b.x, this.y + b.y);
	}

	public function addTo(b:Vector2)
	{
		this.x += b.x;
		this.y += b.y;

		return this;
	}
	
	public function subtract(b:Vector2)
	{
		return new Point2(this.x - b.x, this.y - b.y);
	}

	public function subtractFrom(b:Vector2)
	{
		this.x -= b.x;
		this.y -= b.y;

		return this;
	}

	// TODO: Add intersection functions

	public function equal(other:Point2)
	{
		return this.x == other.x && this.y == other.y;
	}
}
