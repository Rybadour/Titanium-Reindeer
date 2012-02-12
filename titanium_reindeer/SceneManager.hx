package titanium_reindeer;

class SceneManager
{
	public var game:Game;

	private var scenes:Hash<Scene>;

	public function new(game:Game)
	{
		this.game = game;

		this.scenes = new Hash();
	}

	public function addScene(scene:Scene):Void
	{
		if ( !this.scenes.exists(scene.name) )
		{
			this.scenes.set(scene.name, scene);
		}
	}

	public function update(msTimeStep:Int):Void
	{
		for (scene in this.scenes)
		{
			scene.update(msTimeStep);
		}
	}
}
