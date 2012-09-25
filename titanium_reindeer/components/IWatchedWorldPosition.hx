package titanium_reindeer.components;

import titanium_reindeer.core.Watcher;

interface IWatchedWorldPosition
{
	public var worldPosition(getWorldPosition, null):Watcher<Vector2>;
	public function getWorldPosition():Watcher<Vector2>;
}
