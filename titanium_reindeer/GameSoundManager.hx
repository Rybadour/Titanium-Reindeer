package titanium_reindeer;

class GameSoundManager extends SoundManager
{
	private var game:Game;
	private var cachedSounds:Hash<SoundSource>;

	public function new(game:Game)
	{
		this.game = game;
		this.cachedSounds = new Hash();

		super();
	}

	public override function getSoundSource(filePath:String):SoundSource
	{
		if (cachedSounds.exists(filePath))
			return cachedSounds.get(filePath);
		else
		{
			var newSound:SoundSource = new SoundSource(filePath);
			cachedSounds.set(filePath, newSound);
			return newSound;
		}
	}

	private override function propagateCall(methodName:String, params:Array<Dynamic>):Void
	{
		super.propagateCall(methodName, params);

		for (scene in this.game.sceneManager.getAllScenes())
			Reflect.callMethod(scene.soundManager, Reflect.field(scene.soundManager, methodName), params);
	}
}
