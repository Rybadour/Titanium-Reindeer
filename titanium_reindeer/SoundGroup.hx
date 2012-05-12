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
						this.channelsPlaying[i] = false;
						var me:SoundGroup = this;
						this.soundChannels[i].addEventListener("ended", function() { me.channelEnded(i); }, true);
						this.soundChannels[i].volume = this.volume;
					}
				}
			}

			this.numChannels = value;
		}
		return this.numChannels;
	}

	private var soundChannels:Array<Dynamic>;
	private var channelsPlaying:Array<Bool>;
	private var lastChannelUsed:Int;

	private var sounds:Hash<SoundSource>;

	public var soundManager(default, null):SoundManager;

	public function new(soundManager:SoundManager, numChannels:Int = 4)
	{
		this.soundManager = soundManager;
		this.soundManager.addGroup(this);

		this.soundChannels = new Array();
		this.channelsPlaying = new Array();
		this.lastChannelUsed = -1;
		this.numChannels = numChannels;

		this.sounds = new Hash();

		super();
	}

	public function switchManager(newSoundManager:SoundManager):Void
	{
		if (this.soundManager == newSoundManager)
			return;

		this.soundManager.removeGroup(this);

		this.soundManager = newSoundManager;
		this.soundManager.addGroup(this);
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
		if (channel.src != sound.sound.src)
		{
			channel.src = sound.sound.src;
			channel.load();
			channel.play();
			this.channelsPlaying[this.lastChannelUsed] = true;
		}
		else
		{
			channel.pause();
			channel.currentTime = channel.startTime;
			if (!this.pausedState)
			{
				channel.play();
				this.channelsPlaying[this.lastChannelUsed] = true;
			}
		}

		channel.volume = this.trueVolume;
		channel.muted = this.mutedState;
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

	private function channelEnded(index:Int):Void
	{
		if (index < this.numChannels && index >= 0)
		{
			this.channelsPlaying[index] = false;
		}
	}

	private override function setMutedState(value:Bool):Bool
	{
		value = super.setMutedState(value);

		for (channel in this.soundChannels)
			channel.muted = value;

		return value;
	}

	private override function setPausedState(value:Bool):Bool
	{
		value = super.setPausedState(value);

		for (i in 0...this.numChannels)
		{
			if (value)
				this.soundChannels[i].pause();
			else if (this.channelsPlaying[i])
				this.soundChannels[i].play();
		}

		return value;
	}

	private override function setTrueVolume(value:Float):Float
	{
		if (this.trueVolume != value)
		{
			value = super.setTrueVolume(value);

			for (channel in this.soundChannels)
				channel.volume = value;
		}

		return value;
	}
}
