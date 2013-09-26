package titanium_reindeer;

class CollisionRect extends CollisionComponent
{
	public function new(width:Float, height:Float, layer:String, group:String)
	{
		super(width, height, layer, group);
	}

	override public function collide(otherCompId:Int):Void
	{
		var otherComp:CollisionComponent = this.collisionManager.getComponent(otherCompId);
		if (otherComp == null)
			return;
		
		if (Std.is(otherComp, CollisionRect))
		{
			super.collide(otherCompId);
		}
		else if (Std.is(otherComp, CollisionCircle))
		{
			var circleComp:CollisionCircle = cast(otherComp, CollisionCircle);
			if ( Geometry.isCircleIntersectingRect(new Circle(circleComp.radius, circleComp.getCenter()), this.getMinBoundingRect()) )
			{
				super.collide(otherCompId);
			}
		}
	}
}
