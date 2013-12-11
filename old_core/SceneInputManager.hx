package titanium_reindeer;

import titanium_reindeer.InputManager;

class SceneInputManager extends InputManager
{
	private var scene:Scene;

	public function new(scene:Scene)
	{
		super();

		this.scene = scene;
	}

	public override function receiveEvent(recordedEvent:RecordedEvent):Void
	{
		if ( !this.scene.isPaused )
			super.receiveEvent(recordedEvent);
	}
}
