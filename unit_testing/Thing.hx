import titanium_reindeer.core.Watcher;
import titanium_reindeer.components.IWatchedWorldPosition;

import titanium_reindeer.Vector2;

class Thing implements IWatchedWorldPosition
{
	public var worldPosition:WVector2;

	public function new()
	{
		this.worldPosition = new WVector2(0, 0);
	}
}
