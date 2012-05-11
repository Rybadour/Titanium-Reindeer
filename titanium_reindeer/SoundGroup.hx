package titanium_reindeer;

class SoundGroup extends SoundBase
{
	public var numChannels(default, setNumChannels):Int;
	private function setNumChannels(value:Int):Int
	{
		if (this.numChannels != value)
		{
			// Add more
			if (this.numChannels < value)
			{
				for (i in this.numChannels...value)
				{
					untyped
					{
						__js__("this.soundChannels[i] = new Audio();");
						this.soundChannels[i].volume = this.volume;
					}
				}
			}

			this.numChannels = value;
		}
		return this.numChannels;
	}

	private var soundChannels:Array<Dynamic>;
	private var lastChannelUsed:Int;

	private var sounds:Hash<SoundSource>;

	public function new(soundManager:SoundManager, numChannels:Int)
	{
		super();

		this.soundManager = soundManager;
		this.soundManager.addSoundGroup(this);

		this.soundChannels = new Array();
		this.lastChannelUsed = -1;
		this.numChannels = numChannels;

		this.sounds = new Hash();
	}

	public function addSound(name:String, sound:Sound):Void
	{
		if (name == null || name == "" || sound == null)
			return;

		this.sounds.set(name, sound.soundSource);
	}

	public function addSoundSource(name:String, sound:SoundSource):Void
	{
		if (name == null || name == "" || sound == null)
			return;

		this.sounds.set(name, sound);
	}

	public function playSound(soundName:String):Void
	{
		if (soundName == null || !this.sounds.exists(soundName))
			return;

		var sound:SoundSource = this.sounds.get(soundName);
		if (!sound.isLoaded)
			return;
		
		this.lastChannelUsed = (this.lastChannelUsed == this.numChannels-1) ? 0 : this.lastChannelUsed+1;

		var channel:Dynamic = this.soundChannels[this.lastChannelUsed];
		channel.src = sound.sound.src;
		channel.load();
		channel.play();
	}

	public function playRandomSound(soundNames:Array<String>):Int
	{
		if (soundNames == null || soundNames.length == 0)
			return -1;

		var r:Int = Std.random(soundNames.length);
		if (soundNames[r] == null)
			return -1;
		else
		{
			playSound(soundNames[r]);
			return r;
		}
	}
}
