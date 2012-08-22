package titanium_reindeer.components;

import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.Relation;
import titanium_reindeer.core.IProvidesIds;

class CircleRegion implements IRegion
{
	public var id(default, null):Int;

	public var shape(getShape, null):IShape;
	public function getShape():IShape
	{
		return new Circle(this.radius, worldPosition);
	}

	private var worldPositionRelation:Relation2<Vector2, Vector2, Vector2>;
	public var worldPosition(getWorldPosition, never):Vector2;
	private function getWorldPosition():Vector2
	{
		return this.worldPositionRelation.value;
	}

	private var watchedOffset:Watcher<Vector2>;
	public var offset(getOffset, setOffset):Vector2;
	private function getOffset():Vector2
	{
		return this.watchedOffset.value;
	}
	private function setOffset(value:Vector2):Vector2
	{
		this.watchedOffset.value = value;
		return this.watchedOffset.value;
	}

	public var anchor(default, null):IWatchedWorldPosition;
	public var radius(default, setRadius):Float;
	public function setRadius(value:Float):Float
	{
		if (this.radius != value)
		{
			this.radius = value;
		}

		return this.radius;
	}

	public function new(idProvider:IProvidesIds, anchor:IWatchedWorldPosition, radius:Float)
	{
		this.id = idProvider.requestId();

		this.anchor = anchor;
		this.radius = radius;
		this.watchedOffset = new Watcher(new Vector2(0, 0));

		this.worldPositionRelation = new Relation2(this.anchor.worldPosition, this.watchedOffset, findWorldPosition);
	}

	private function findWorldPosition(anchorPosition:Vector2, offset:Vector2):Vector2
	{
		return anchorPosition.add(offset);
	}

	public function update(msTimeStep:Int):Void
	{
	}
}
