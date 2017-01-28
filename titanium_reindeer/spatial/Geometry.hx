package titanium_reindeer.spatial;

import titanium_reindeer.util.MoreMath;

// A series of static methods for common geometric calculations
class Geometry
{
	/**
	 * Returns true if a and b intersect at all. Assumes Axis aligned (AABB) rects.
	 */
	public static function isRectIntersectingRect(a:RectRegion, b:RectRegion):Bool
	{
		return (a.right >= b.left) && (a.left <= b.right) &&
			   (a.bottom >= b.top) && (a.top <= b.bottom);
	}

	/**
	 * Returns true if a and b intersect at all
	 */
	public static function isCircleIntersectingCircle(a:CircleRegion, b:CircleRegion):Bool
	{
		return a.radius + b.radius > Vector2.getDistance(a.center, b.center);
	}

	/**
	 * Returns true if a is wholly inside b.
	 */
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
			var right:Float = Math.min(a.right, b.right);
			var top:Float = Math.max(a.top, b.top); 
			var bottom = Math.min(a.bottom, b.bottom);
			return new RectRegion(
				(right - left), 
				(bottom - top), 
				new Vector2(left, top)
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

	/**
	 * Returns true if the given target angle is inside of a pair of angles made by start + bounds
	 * and start - bounds, inclusive. All angles are in radians.
	 * Care was taken to ensure that angles around Math.PI * 2 are checked accruately. Basically,
	 * the angles are normalized to 0 relative to start.
	 */
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

	public static function isAngleWithinPair(start:Float, end:Float, target:Float):Bool
	{
		var dist = Geometry.distanceBetweenAngles(start, end);
		return Geometry.isAngleWithin(start + dist/2, target, dist/2);
	}

	public static function distanceBetweenAngles(a:Float, b:Float):Float
	{
		return Math.abs(MoreMath.unsignedModulo((b - a + Math.PI), (Math.PI*2)) - Math.PI);
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

	/**
	 * Returns true if b is within 180 of a going counter-clockwise.
	 */
	public static function isAngleToTheRight(a:Float, b:Float):Bool
	{
		a = MoreMath.unsignedModulo(a, Math.PI*2);
		b = MoreMath.unsignedModulo(b, Math.PI*2);
		var bRelative = MoreMath.unsignedModulo(b - a, Math.PI*2);
		return (bRelative < Math.PI);
	}

	/**
	 * Get the average center point of a list of points.
	 */
	public static function getCentroid(points:Array<Vector2>):Vector2
	{
		if (points.length == 0)
			return null;

		var totalX:Float = 0;
		var totalY:Float = 0;
		for (p in points)
		{
			totalX += p.x;
			totalY += p.y;
		}
		return new Vector2(totalX / points.length, totalY / points.length);
	}

	public static function getRectRegionFromCorners(a:Vector2, b:Vector2):RectRegion
	{
		var topLeft = new Vector2(Math.min(a.x, b.x), Math.min(a.y, b.y));
		return new RectRegion(
			Math.abs(a.x - b.x),
			Math.abs(a.y - b.y),
			topLeft
		);
	}

	public static function moveCircleToEdgeOfRectangle(circle:CircleRegion, rect:RectRegion):Vector2
	{
		var side = new Vector2(0, 0);

		if (rect.top >= circle.center.y)
			side.y = (circle.center.y - rect.top);
		else if (rect.bottom <= circle.center.y)
			side.y = (circle.center.y - rect.bottom);

		if (rect.left >= circle.center.x)
			side.x = (circle.center.x - rect.left);
		else if (rect.right <= circle.center.x)
			side.x = (circle.center.x - rect.right);

		// Circle needs to be radius - distance more away from the rect in which ever direction
		var distance = side.getMagnitude();
		side.setMagnitude(circle.radius - distance);

		return circle.center.add(side);
	}

	/**
	 * Takes an array of rectangles and returns an array of rectangles containing a smaller or equal
	 * set of rectangles. It will take any overlapping or touching retangles and merge them together
	 * and recurses until no merging happens.
	 */
	public static function simplifyClusterOfRectRegions(rects:Array<RectRegion>):Array<RectRegion>
	{
		var mergedAny = false;
		var mergedRects:Array<RectRegion> = null;
		var nextMergedRects = rects.copy();

		do
		{
			mergedAny = false;
			mergedRects = nextMergedRects;
			nextMergedRects = new Array();
			var mergedRectIndices:Map<Int, Bool> = new Map();
			var i = 0;
			for (rect in mergedRects)
			{
				if ( ! mergedRectIndices.exists(i))
				{
					var newRect = RectRegion.copy(rect);
					for (j in (i+1)...mergedRects.length)
					{
						var otherRect = mergedRects[j];
						// Above or below?
						if (newRect.left == otherRect.left && newRect.right == otherRect.right)
						{
							if (newRect.top - 1 <= otherRect.bottom && newRect.bottom + 1 >= otherRect.top)
							{
								newRect = RectRegion.expandToCover(newRect, otherRect);
								mergedRectIndices.set(j, true);	
								mergedAny = true;
							}
						}
						// Side by side?
						else if (newRect.top == otherRect.top && newRect.bottom == otherRect.bottom)
						{
							if (newRect.left - 1 <= otherRect.right && newRect.right + 1 >= otherRect.left)
							{
								newRect = RectRegion.expandToCover(newRect, otherRect);
								mergedRectIndices.set(j, true);	
								mergedAny = true;
							}
						}
						
						// Maybe one is inside the other
						// If newRect is bigger we just "drop" otherRect, otherwise we keep
						// otherRect and "drop" newRect
						if (newRect.getArea() > otherRect.getArea())
						{
							if (newRect.fullyCoversRectRegion(otherRect))
							{
								mergedRectIndices.set(j, true);	
								mergedAny = true;
							}
						}
						else
						{
							if (otherRect.fullyCoversRectRegion(newRect))
							{
								newRect = otherRect;
								mergedRectIndices.set(i, true);	
								mergedAny = true;
							}
						}
					}
					nextMergedRects.push(newRect);
				}

				++i;
			}
		}
		while(mergedAny);

		return nextMergedRects;
	}

	public static function getClosestPointOnLine(a:Vector2, b:Vector2, p:Vector2)
	{
		// TODO: Look up this math again, it's returning negatives
		var aToP = p.subtract(a);
		var aToB = b.subtract(a);

		var abSquared = aToB.getMagnitudeSquared();
		var abProduct = Vector2.getDotProduct(aToP, aToB);
		var aToClosestDist = abProduct / abSquared;

		aToB.extend(aToClosestDist);
		return a.add(aToB);
	}

	public static function getClosestPointOnLineSegment(a:Vector2, b:Vector2, p:Vector2)
	{
		var aToP = p.subtract(a);
		var aToB = b.subtract(a);

		var abSquared = aToB.getMagnitudeSquared();
		var abProduct = Vector2.getDotProduct(aToP, aToB);
		var aToClosestDist = abProduct / abSquared;

		if (aToClosestDist < 0)
		{
			return a.getCopy();
		}
		else if (aToClosestDist > 1)
		{
			return b.getCopy();
		}
		else
		{
			aToB.extend(aToClosestDist);
			return a.add(aToB);
		}
	}

	public static function isCircleIntersectingRotatedRectangle(cPos:Vector2, cRad:Float, rTopLeft:Vector2, rWidth:Float, rHeight:Float, rRad:Float):Bool
	{
		var circle:CircleRegion = new CircleRegion(cRad, cPos);
		var rect:RectRegion = new RectRegion(rWidth, rHeight, new Vector2(0, 0));
	
		// Normalize the circle to the orientation of the rotated rect.
		circle.center.subtractFrom(rTopLeft);
		circle.center.rotate(-rRad);

		return Geometry.isCircleIntersectingRect(circle, rect);
	}
}
