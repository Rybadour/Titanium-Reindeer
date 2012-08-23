import titanium_reindeer.core.Watcher;
import titanium_reindeer.components.IWatchedWorldPosition;

import titanium_reindeer.Vector2;

class Thing implements IWatchedWorldPosition
{
	public var worldPosition(default, null):Watcher<Vector2>;

	public var position(getPos, setPos):Vector2;
	private function getPos():Vector2
	{
		return worldPosition.value;
	}
	private function setPos(value:Vector2):Vector2
	{
		this.worldPosition.value = value;
		return this.worldPosition.value;
	}

	public function new()
	{
		this.worldPosition = new Watcher(new Vector2(0, 0));
	}
}
