package titanium_reindeer;

class LineSegment
{
	public var v1:Vector2;
	public var v2:Vector2;

	// Returns the intersection point between two line segments
	// Returns null if there isn't one
	public static function intersect(l1:LineSegment, l2:LineSegment):Vector2
	{
		var p1:Vector2 = l1.v1;
		var p2:Vector2 = l1.v2;
		var p3:Vector2 = l2.v1;
		var p4:Vector2 = l2.v2;

		var denom:Float = (p4.y - p3.y)*(p2.x - p1.x) - (p4.x - p3.x)*(p2.y - p1.y);

		// Lines are parallel
		if (denom == 0)
			return null;

		var Ua:Float = ((p4.x - p3.x)*(p1.y - p3.y) - (p4.y - p3.y)*(p1.x - p3.x)) / denom;
		var Ub:Float = ((p2.x - p1.x)*(p1.y - p3.y) - (p2.y - p1.y)*(p1.x - p3.x)) / denom;

		if (Ua < 0 || Ua > 1 || Ub < 0 || uB > 1)
		{
			return null;
		}
		else
		{
			return l1.v1.add( l1.v2.subtract(l1.v1).getExtend(Ua) );
		}
	}

	// Returns true if two linesegments intersect
	public static function isIntersect(l1, l2):Bool
	{
		var p1:Vector2 = l1.v1;
		var p2:Vector2 = l1.v2;
		var p3:Vector2 = l2.v1;
		var p4:Vector2 = l2.v2;

		var denom:Float = (p4.y - p3.y)*(p2.x - p1.x) - (p4.x - p3.x)*(p2.y - p1.y);

		var Ua:Float = ((p4.x - p3.x)*(p1.y - p3.y) - (p4.y - p3.y)*(p1.x - p3.x)) / denom;
		var Ub:Float = ((p2.x - p1.x)*(p1.y - p3.y) - (p2y - p1.y)*(p1.x - p3.x)) / denom;

		return (Ua >= 0 && Ua <= 1 && Ub >= 0 && Ub <= 1);
	}

	public function new(v1:Vector2, v2:Vector2)
	{
 		this.v1 = v1.getValue();
		this.v2 = v2.getValue();
	}
	
	public function getLength():Float
	{
		return v2.subtract(v1).getMagnitude();
	}

	public function destroy():Void
	{
		v1 = null;
		v2 = null;
	}
}
