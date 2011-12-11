package titanium_reindeer;

class CollisionCircle extends CollisionComponent
{
	public var radius(default, setRadius):Float;
	private function setRadius(value:Float):Float
	{
		if (this.radius != value)
		{
			this.radius = value;

			// When width and height are set it triggers an update to the bounds but this is ineffiecent to do twice
			this.allowUpdateBounds = false;
			this.width = value*2;
			this.height = value*2;
			this.allowUpdateBounds = true;
			this.updateBounds();
		}

		return this.radius;
	}

	public function new(radius:Float, layer:String, group:String)
	{
		super(radius*2, radius*2, layer, group);
		this.radius = radius;
	}

	override public function collide(otherCompId:Int):Void
	{
		var otherComp:CollisionComponent = this.collisionManager.getComponent(otherCompId);
		if (otherComp == null)
			return;
		
		if (Std.is(otherComp, CollisionCircle))
		{
			var circleComp:CollisionCircle = cast(otherComp, CollisionCircle);
			if ( Circle.isIntersecting(new Circle(this.radius, this.getCenter()), new Circle(circleComp.radius, circleComp.getCenter())) )
			{
				super.collide(otherCompId);
			}
		}
		else if (Std.is(otherComp, CollisionRect))
		{
			var rectComp:CollisionRect = cast(otherComp, CollisionRect);
			if ( Geometry.isCircleIntersectingRect(new Circle(this.radius, this.getCenter()), rectComp.getMinBoundingRect()) )
			{
				super.collide(otherCompId);
			}
		}
	}

	override public function isPointIntersecting(point:Vector2):Bool
	{
		return Geometry.isPointInCircle(point, new Circle(this.radius, this.getCenter()));
	}
}
