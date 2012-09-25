package titanium_reindeer.components;

import titanium_reindeer.core.IWatchedRegion;
import titanium_reindeer.core.RectRegion;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.Relation;

class RectRegionWatched extends RectRegion, implements IWatchedRegion
{
	public var watchedCenter(default, null):Watcher<Vector2>;
	public override function getCenter():Vector2 { return this.watchedCenter.value; }
	public override function setCenter(value:Vector2):Vector2
	{
		this.watchedCenter.value = value;
		return this.watchedCenter.value;
	}

	public function new(width:Float, height:Float, center:Vector2)
	{
		this.watchedCenter = new Watcher(center);

		super(width, height, center);
	}
}
