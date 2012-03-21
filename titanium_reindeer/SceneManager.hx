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

	public function getAllScenes():Iterator<Scene>
	{
		return this.scenes.iterator();
	}

	public function getScene(sceneName:String):Scene
	{
		if ( !this.scenes.exists(sceneName) )
		{
			return this.scenes.get(sceneName);
		}

		return null;
	}

	public function addScene(scene:Scene):Void
	{
		if ( !this.scenes.exists(scene.name) )
		{
			this.scenes.set(scene.name, scene);
		}
	}

	public function removeScene(scene:Scene):Void
	{
		if ( this.scenes.exists(scene.name) )
		{
			this.scenes.remove(scene.name);
		}
	}

	public function update(msTimeStep:Int):Void
	{
		for (scene in this.scenes)
		{
			scene.update(msTimeStep);
		}
	}

	public function destroy():Void
	{
		this.game = null;
		for (sceneName in this.scenes.keys())
		{
			this.scenes.get(sceneName).destroy();
			this.scenes.remove(sceneName);
		}
		this.scenes = null;
	}
}
