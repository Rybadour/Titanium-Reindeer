package titanium_reindeer.core;

interface IWatchedRegion implements IRegion
{
	public var watchedCenter(default, null):Watcher<Vector2>;
}
