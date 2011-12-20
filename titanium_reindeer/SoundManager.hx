package titanium_reindeer;

class SoundManager
{
	public var maxSoundChannels(default, setMaxSoundChannels):Int;
	private function setMaxSoundChannels(value:Int):Int
	{
		if (this.maxSoundChannels != value)
		{
			// Add more
			if (this.maxSoundChannels < value)
			{
				for (i in this.maxSoundChannels...value)
				{
					untyped
					{
						__js__("this.soundChannels[i] = new Audio();");
						this.soundChannels[i].volume = globalVolume;
					}
				}
			}

			this.maxSoundChannels = value;
		}
		return this.maxSoundChannels;
	}

	public var globalVolume(default, setGlobalVolume):Float;
	private function setGlobalVolume(value:Float):Float
	{
		if (this.globalVolume != value)
		{
			if (this.soundChannels != null)
			{
				for (channel in this.soundChannels)
					channel.volume = value;
			}

			this.globalVolume = value;
		}

		return this.globalVolume;
	}

	public var isMuted(default, setIsMuted):Bool;
	private function setIsMuted(value:Bool):Bool
	{
		this.isMuted = value;
		return this.isMuted;
	}

	private var soundChannels:Array<Dynamic>;
	private var lastChannelUsed:Int;

	private var cachedSounds:Hash<SoundSource>;

	public function new()
	{
		this.soundChannels = new Array();
		this.lastChannelUsed = -1;

		this.cachedSounds = new Hash();

		this.maxSoundChannels = 32;
		this.globalVolume = 1;
		this.isMuted = false;
	}
	
	public function getSound(filePath:String):SoundSource
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

	public function playSound(sound:SoundSource):Void
	{
		if (this.isMuted || sound == null || !sound.isLoaded)
			return;
		
		this.lastChannelUsed = (this.lastChannelUsed == this.soundChannels.length-1 ? 0 : this.lastChannelUsed+1);

		var channel:Dynamic = this.soundChannels[this.lastChannelUsed];
		channel.src = sound.sound.src;
		channel.load();
		channel.play();
	}

	public function playRandomSound(possibleSounds:Array<SoundSource>):Int
	{
		if (possibleSounds == null || possibleSounds.length == 0)
			return -1;

		var r:Int = Std.random(possibleSounds.length);
		if (possibleSounds[r] == null)
			return -1;
		else
		{
			playSound(possibleSounds[r]);
			return r;
		}
	}
}
