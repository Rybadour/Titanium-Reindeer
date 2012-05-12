package titanium_reindeer;

class SoundManager extends SoundBase
{
	private var sounds:Hash<Sound>;
	private var soundGroups:Array<SoundGroup>;

	public function new()
	{
		this.sounds = new Hash();
		this.soundGroups = new Array();

		super();
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
		if (soundGroup == null || soundGroup.soundManager != this || this.containsGroup(soundGroup))
			return;

		this.soundGroups.push(soundGroup);
	}

	public function containsGroup(soundGroup:SoundGroup):Bool
	{
		for (mySoundGroup in this.soundGroups)
		{
			if (soundGroup == mySoundGroup)
				return true;
		}
		return false;
	}

	public function removeGroup(soundGroup:SoundGroup):Void
	{
		this.soundGroups.remove(soundGroup);
	}

	private override function propagateCall(methodName:String, params:Array<Dynamic>):Void
	{
		for (sound in this.sounds)
			Reflect.callMethod(sound, Reflect.field(sound, methodName), params);

		for (soundGroup in this.soundGroups)
			Reflect.callMethod(soundGroup, Reflect.field(soundGroup, methodName), params);
	}
}
