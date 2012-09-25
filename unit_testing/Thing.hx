import titanium_reindeer.core.Watcher;
import titanium_reindeer.components.IWatchedWorldPosition;

import titanium_reindeer.Vector2;

class Thing implements IWatchedWorldPosition
{
	public var worldPosition(getWorldPosition, null):Watcher<Vector2>;
	public function getWorldPosition():Watcher<Vector2> { return this.worldPosition; }

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
