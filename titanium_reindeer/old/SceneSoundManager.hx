package titanium_reindeer;

class SceneSoundManager extends SoundManager
{
	public var scene(default, null):Scene;

	public function new(scene:Scene)
	{
		super();

		this.scene = scene;
	}

	public override function getSoundSource(filePath:String):SoundSource
	{
		return this.scene.game.soundManager.getSoundSource(filePath);
	}
}
