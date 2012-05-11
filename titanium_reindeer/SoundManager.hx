package titanium_reindeer;

class SoundManager extends SoundBase
{
	private var sounds:Hash<Sound>;
	private var soundGroups:IntHash<SoundSource>;

	private var nextGroupId:Int;

	public function new()
	{
		this.sounds = new Hash();
		this.soundGroups = new IntHash();

		this.nextGroupId = 0;
	}

	public function getSound(filePath:String):Sound
	{
		if (this.sounds.exists(filePath))
		{
			return this.sounds.get(filePath);
		}

		var newSound:Sound = new Sound(this, this.getSoundSource(filePath));
		this.sounds.set(filePath, newSound);
		return newSound;
	}
	
	// No Proper Abstract methods in Haxe, this will get overrided
	public function getSoundSource(filePath:String):SoundSource
	{
		return null;
	}

	public function addGroup(soundGroup:SoundGroup):Void
	{
		if (soundGroup == null)
			return;

		this.soundGroups.set(this.nextGroupId, soundGroup);

		soundGroup.id = this.nextGroupId;
		this.nextGroupId++;
	}

	public function removeGroup(soundGroup:SoundGroup):Void
	{

	}
}
