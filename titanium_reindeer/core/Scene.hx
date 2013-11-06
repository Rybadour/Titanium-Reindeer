package titanium_reindeer.core;

class Scene 
{
	public var isPaused(default, null):Bool;

	public function new()
	{
		this.isPaused = false;
	}

	public function pause():Void
	{
		this.isPaused = true;
	}

	public function unpause():Void
	{
		this.pause = false;
	}
}
