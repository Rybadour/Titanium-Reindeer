package titanium_reindeer.components;

class ShapeIntersecter implements IShapeIntersecter
{
	public function isIntersecting(a:IShape, b:IShape):Bool
	{
		if ( Std.is(a, Rect) )
		{
			if ( Std.is(b, Rect) )
				return Rect.isIntersecting( cast(a, Rect), cast(b, Rect) );
			else if ( Std.is(b, Circle) )
				return Geometry.isCircleIntersectingRect( cast(b, Circle), cast(a, Rect) );
		}
		else if ( Std.is(a, Circle) )
		{
			if ( Std.is(b, Rect) )
				return Geometry.isCircleIntersectingRect( cast(a, Circle), cast(b, Rect) );
			else if ( Std.is(b, Circle) )
				return Circle.isIntersecting( cast(a, Circle), cast(b, Circle) );
		}
		
		return false;
	}

	public function new()
	{
	}
}
