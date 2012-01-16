package titanium_reindeer;

class Rect extends Shape
{
	// Static
	public static function isIntersecting(a:Rect, b:Rect):Bool
	{
		return (a.x + a.width >= b.x) && (a.x <= b.x + b.width) &&
			   (a.y + a.height >= b.y) && (a.y <= b.y + b.height);
	}

	public static function getIntersection(a:Rect, b:Rect):Rect
	{	
		// True if the rectangle intersects
		if ( (a.x + a.width >= b.x) && (a.x <= b.x + b.width) && (a.y + a.height >= b.y) && (a.y <= b.y + b.height) )
		{
			var left:Float = Math.max(a.x, b.x);
			var top:Float = Math.max(a.y, b.y); 
			return new Rect(
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

	public static function isWithin(a:Rect, b:Rect):Bool
	{
		return (a.x <= b.x) && (a.x + a.width  >= b.x + b.width) &&
			   (a.y <= b.y) && (a.y + a.height >= b.y + b.height);
	}

	public static function expandToCover(coverage:Rect, toFit:Rect):Rect
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
		return new Rect(
			x, y,
			Math.max(coverage.right, toFit.right) - x,
			Math.max(coverage.bottom, toFit.bottom) - y
		);
	}

	// Instance
	public var x:Float;
	public var y:Float;

	public var width:Float;
	public var height:Float;

	public var top(getTop, never):Float;
	private function getTop():Float
	{
		return y;
	}
	public var bottom(getBottom, never):Float;
	private function getBottom():Float
	{
		return y + height;
	}
	public var left(getLeft, never):Float;
	private function getLeft():Float
	{
		return x;
	}
	public var right(getRight, never):Float;
	private function getRight():Float
	{
		return x + width;
	}

	public function new(x:Float, y:Float, width:Float, height:Float)
	{
		this.x = x;
		this.y = y;

		this.width = width;
		this.height = height;
	}

	public override function getMinBoundingRect():Rect
	{
		return this.getCopy();
	}

	public override function isPointInside(p:Vector2):Bool
	{
		return (p.x >= this.left) && (p.x < this.right) &&
			   (p.y >= this.top)  && (p.y < this.bottom);
	}

	public function getCopy():Rect
	{
		return new Rect(this.x, this.y, this.width, this.height);
	}

	public function getArea():Float
	{
		return width * height;
	}
}
