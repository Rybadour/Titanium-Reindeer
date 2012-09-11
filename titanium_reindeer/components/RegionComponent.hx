package titanium_reindeer.components;

import titanium_reindeer.core.IHasId;

class RegionComponent implements IHasId, implements IWatchedWorldPosition, implements IRegion
{
	public var id(default, null):Int;
	public var shape(default, null):IShape;

	public var localPosition(getLocalPosition, setLocalPosition):Vector2;
	private function getLocalPosition():Vector2
	{
		return this.shape.center;
	}
	private function setLocalPosition(value:Vector2):Vector2
	{
		this.shape.center = value;
		return this.shape.center;
	}

	private var worldPositionRelation:Relation2<Vector2, Vector2, Vector2>;
	public var worldPosition(getWorldPosition, never):Vector2;
	private function getWorldPosition():Vector2
	{
		return this.worldPositionRelation.value;
	}

	public var anchor(default, null):IWatchedWorldPosition;

	public function new(provider:IHasIdProvider, anchor:IWatchedWorldPosition, shape:IShape)
	{
		this.id = provider.idProvider.requestId();
		this.shape = shape;
		this.anchor = anchor;

		this.worldPositionRelation = new Relation2(this.anchor.worldPosition, this.region.watchedOffset, findWorldPosition);
	}

	private function findWorldPosition(anchorPosition:Vector2, localPosition:Vector2):Vector2
	{
		return anchorPosition.add(localPosition);
	}
}
