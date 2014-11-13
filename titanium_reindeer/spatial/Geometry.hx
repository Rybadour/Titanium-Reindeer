package titanium_reindeer.spatial;

// A series of static methods for common geometric calculations
class Geometry
{
	public static function isRectIntersectingRect(a:RectRegion, b:RectRegion):Bool
	{
		return (a.right >= b.left) && (a.left <= b.right) &&
			   (a.bottom >= b.top) && (a.top <= b.bottom);
	}

	public static function isCircleIntersectingCircle(a:CircleRegion, b:CircleRegion):Bool
	{
		return a.radius + b.radius > Vector2.getDistance(a.center, b.center);
	}

	public static function isCircleInsideCircle(a:CircleRegion, b:CircleRegion):Bool
	{
		var dist = Vector2.getDistance(a.center, b.center);	
		return (dist + a.radius <= b.radius);
	}

	public static function isCircleIntersectingRect(c:CircleRegion, r:RectRegion):Bool
	{
		var rWidthHalf:Float = r.width/2;
		var rHeightHalf:Float = r.height/2;

		// Step A: calculate the absolute values of the x and y difference between the center of the circle and the center of the rectangle. 
		// This collapses the four quadrants down into one, so that the calculations do not have to be done four times.
		var circleDistX:Float = Math.abs(c.center.x - r.center.x);
		var circleDistY:Float = Math.abs(c.center.y - r.center.y);

		// Step B: eliminate the easy cases where the circle is far enough away from the rectangle (in either direction) that no intersection is possible.
		if (circleDistX > rWidthHalf + c.radius || circleDistY > rHeightHalf + c.radius)
			return false;

		// Step C: eliminates the easy cases where the circle's center lies inside the rect. This check allows us to usually skip the expensive step D.
		// This check is only valid after Step B.
		if (circleDistX <= rWidthHalf || circleDistY <= rHeightHalf)
			return true;

		// Step D: compute the distance from the center of the circle and the corner, and then verify that the distance is not more than the radius of the circle.
		var cornerDistance:Float = (circleDistX-rWidthHalf)*(circleDistX-rWidthHalf) + (circleDistY-rHeightHalf)*(circleDistY-rHeightHalf);
		return cornerDistance <= (c.radius * c.radius);
	}

	public static function getIntersectionOfRectRegions(a:RectRegion, b:RectRegion):RectRegion
	{        
		// True if the rectangle intersects
		if ( (a.right >= b.left) && (a.left <= b.right) && (a.bottom >= b.top) && (a.top <= b.bottom) )
		{
			var left:Float = Math.max(a.left, b.left);
			var top:Float = Math.max(a.top, b.top); 
			return new RectRegion(
				left, 
				top, 
				new Vector2(
					Math.min(a.right, b.right) - left, 
					Math.min(a.bottom, b.bottom) - top
				)
			);
		}
		else
		{
			return null;
		}
	}

	public static function getMidPoint(a:Vector2, b:Vector2):Vector2
	{
		// Could be replaced with a.add(b).getExtend(0.5);
		return b.add( a.subtract(b).getExtend(0.5) );
	}

	public static function isAngleWithin(start:Float, target:Float, bounds:Float):Bool
	{
		if (bounds >= Math.PI)
			return true;

		var diff:Float = ((target - start) % (Math.PI*2));
		if (start > target)
			diff += Math.PI*2;
		if (diff >= Math.PI)
			diff = -(diff - Math.PI*2);

		return bounds >= diff;
	}

	public static function closestAngle(rad:Float, comparisons:Array<Float>):Float
	{
		// Simple cases
		if (comparisons == null || comparisons.length == 0)
			return rad;
		if (comparisons.length == 1)
			return comparisons.pop();

		var closestComparison:Float = rad; // set to a "reasonable" default, but this will be overridden
		var closestDiff:Float = Math.POSITIVE_INFINITY;
		var diff:Float;
		for (comparison in comparisons)
		{
			diff = ((comparison - rad) % (Math.PI*2));
			if (rad > comparison)
				diff += Math.PI*2;
			if (diff >= Math.PI)
				diff = -(diff - Math.PI*2);

			if (closestDiff > diff)
			{
				closestComparison = comparison % (Math.PI*2);
				closestDiff = diff;
			}
		}

		return closestComparison;
	}
}
