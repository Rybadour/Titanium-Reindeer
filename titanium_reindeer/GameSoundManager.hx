package titanium_reindeer;

class GameSoundManager extends SoundManager
{
	private var cachedSounds:Hash<SoundSource>;

	public function new()
	{
		super();

		this.cachedSounds = new Hash();
	}

	public function getSoundSource(filePath:String):SoundSource
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
}
