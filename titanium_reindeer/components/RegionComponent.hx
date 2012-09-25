package titanium_reindeer.components;

import titanium_reindeer.core.IHasId;
import titanium_reindeer.core.IRegion;
import titanium_reindeer.core.IWatchedRegion;
import titanium_reindeer.core.Relation;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;

class RegionComponent<RegionT:IWatchedRegion>
	implements IWorldPosition,
	implements IHasId
{
	public var id(default, null):Int;

	public var region(default, null):RegionT;

	public var localPosition(getLocalPosition, setLocalPosition):Vector2;
	private function getLocalPosition():Vector2
	{
		return this.region.watchedCenter.value;
	}
	private function setLocalPosition(value:Vector2):Vector2
	{
		this.region.watchedCenter.value = value;
		return this.region.watchedCenter.value;
	}

	private var worldPositionRelation:Relation2<Vector2, Vector2, Vector2>;
	public var worldPosition(getWorldPosition, null):Vector2;
	public function getWorldPosition():Vector2
	{
		return this.worldPositionRelation.value;
	}

	public var anchor(default, null):IWatchedWorldPosition;

	public function new(provider:IHasIdProvider, anchor:IWatchedWorldPosition, region:RegionT)
	{
		this.id = provider.idProvider.requestId();
		this.region = region;
		this.anchor = anchor;

		this.worldPositionRelation = new Relation2(this.anchor.worldPosition, this.region.watchedCenter, findWorldPosition);
	}

	private function findWorldPosition(anchorPosition:Vector2, localPosition:Vector2):Vector2
	{
		return anchorPosition.add(localPosition);
	}
}
