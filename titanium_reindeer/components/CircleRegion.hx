package titanium_reindeer.components;

import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.Relation;
import titanium_reindeer.core.IHasIdProvider;

class CircleRegion implements IRegion
{
	public var shape(getShape, null):IShape;
	public function getShape():IShape
	{
		return new Circle(this.radius, worldPosition);
	}

	public var radius(default, setRadius):Float;
	public function setRadius(value:Float):Float
	{
		if (this.radius != value)
		{
			this.radius = value;
		}

		return this.radius;
	}

	public function new(radius:Float)
	{
		this.radius = radius;
		this.watchedOffset = new Watcher(new Vector2(0, 0));
	}
}
