package titanium_reindeer.spatial;

class RegionIntersecter implements IRegionIntersecter
{
	public function isIntersecting(a:IRegion, b:IRegion):Bool
	{
		if ( !Std.is(a, RectRegion) && !Std.is(a, CircleRegion) )
			a = a.getBoundingRectRegion();
		if ( !Std.is(b, RectRegion) && !Std.is(b, CircleRegion) )
			b = b.getBoundingRectRegion();

		if ( Std.is(a, RectRegion) )
		{
			if ( Std.is(b, RectRegion) )
				return Geometry.isRectIntersectingRect( cast(a, RectRegion), cast(b, RectRegion) );
			else if ( Std.is(b, CircleRegion) )
				return Geometry.isCircleIntersectingRect( cast(b, CircleRegion), cast(a, RectRegion) );
		}
		else if ( Std.is(a, CircleRegion) )
		{
			if ( Std.is(b, RectRegion) )
				return Geometry.isCircleIntersectingRect( cast(a, CircleRegion), cast(b, RectRegion) );
			else if ( Std.is(b, CircleRegion) )
				return Geometry.isCircleIntersectingCircle( cast(a, CircleRegion), cast(b, CircleRegion) );
		}
		
		return false;
	}

	public function new()
	{
	}
}
