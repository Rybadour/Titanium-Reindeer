package titanium_reindeer.components;

import titanium_reindeer.core.Watcher;

interface IWatchedWorldPosition
{
	public var worldPosition(default, null):Watcher<Vector2>;
}
