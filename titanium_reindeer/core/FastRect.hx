package titanium_reindeer.core;

class FastRect
{
	// Static
	public static function isIntersecting(a:FastRect, b:FastRect):Bool
	{
		return (a.x + a.width >= b.x) && (a.x <= b.x + b.width) &&
			   (a.y + a.height >= b.y) && (a.y <= b.y + b.height);
	}

	public static function getIntersection(a:FastRect, b:FastRect):FastRect
	{	
		// True if the rectangle intersects
		if ( (a.x + a.width >= b.x) && (a.x <= b.x + b.width) && (a.y + a.height >= b.y) && (a.y <= b.y + b.height) )
		{
			var left:Float = Math.max(a.x, b.x);
			var top:Float = Math.max(a.y, b.y); 
			return new FastRect(
				left, 
				top, 
				Math.min(a.x + a.width, b.x + b.width) - left, 
				Math.min(a.y + a.height, b.y + b.height) - top
			);
		}
		else
		{
			return null;
		}
	}

	public static function isWithin(a:FastRect, b:FastRect):Bool
	{
		return (a.x <= b.x) && (a.x + a.width  >= b.x + b.width) &&
			   (a.y <= b.y) && (a.y + a.height >= b.y + b.height);
	}

	public static function expandToCover(coverage:FastRect, toFit:FastRect):FastRect
	{
		if (coverage == null)
		{
			if (toFit == null)
				return null;
			else
				return toFit.getCopy();
		}
		else
		{
			if (toFit == null)
				return coverage.getCopy();
		}

		// Actual stretch checking
		var x:Float = Math.min(coverage.x, toFit.x);
		var y:Float = Math.min(coverage.y, toFit.y);
		return new FastRect(
			x, y,
			Math.max(coverage.right, toFit.right) - x,
			Math.max(coverage.bottom, toFit.bottom) - y
		);
	}

	public static function fromRectRegion(rr:RectRegion):FastRect
	{
		return new FastRect(
			rr.center.x - rr.width/2,
			rr.center.y - rr.height/2,
			rr.width,
			rr.height
		);
	}

	// Instance
	public var x:Float;
	public var y:Float;

	public var width:Float;
	public var height:Float;

	public var top(get, never):Float;
	private function get_top():Float { return y; }

	public var bottom(get, never):Float;
	private function get_bottom():Float { return y + height; }

	public var left(get, never):Float;
	private function get_left():Float { return x; }

	public var right(get, never):Float;
	private function get_right():Float { return x + width; }

	public function new(x:Float, y:Float, width:Float, height:Float)
	{
		this.x = x;
		this.y = y;

		this.width = width;
		this.height = height;
	}

	public function getBoundingRect():FastRect
	{
		return this.getCopy();
	}

	public function isPointInside(p:Vector2):Bool
	{
		return (p.x >= this.left) && (p.x < this.right) &&
			   (p.y >= this.top)  && (p.y < this.bottom);
	}

	public function getCopy():FastRect
	{
		return new FastRect(this.x, this.y, this.width, this.height);
	}

	public function getArea():Float
	{
		return width * height;
	}
}
