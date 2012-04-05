package titanium_reindeer;

class SceneSoundManager extends SoundManager
{
	public var scene(default, null):Scene;

	public var isPaused(default, setIsPaused):Bool;
	private function setIsPaused(value:Bool):Bool
	{
		this.isPaused = value;
		return this.isPaused;
	}

	public function new(scene:Scene)
	{
		this.scene = scene;
		this.isPaused = false;
	}
}
