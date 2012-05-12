package titanium_reindeer;

class Sound extends SoundBase
{
	public var soundManager(default, null):SoundManager;
	public var soundSource(default, null):SoundSource;
	public var sound(default, null):Dynamic;

	public var isLoaded(default, null):Bool;
	public var isPlaying(default, null):Bool;

	public function new(soundManager:SoundManager, soundSource:SoundSource)
	{
		this.soundManager = soundManager;
		this.soundSource = soundSource;

		this.isLoaded = false;
		this.isPlaying = false;

		untyped
		{
			__js__("this.sound = new Audio()");
			this.sound.src = this.soundSource.sound.src;
			this.sound.addEventListener("canplaythrough", this.soundLoaded, true);
			this.sound.load();
			this.sound.addEventListener("ended", this.soundEnded, true);
		}

		super();
	}

	public function play():Void
	{
		if (!this.isLoaded)
		{
			this.isPlaying = true;
			return;
		}

		this.sound.pause();
		this.sound.currentTime = this.sound.startTime;

		if (!this.pausedState)
		{
			this.sound.play();
			this.isPlaying = true;
		}

		this.sound.volume = trueVolume;
		this.sound.muted = this.mutedState;
	}

	private function soundLoaded():Void
	{
		this.isLoaded = true;
		if (this.isPlaying)
			this.play();
	}

	private function soundEnded():Void
	{
		this.isPlaying = false;
	}

	private override function setMutedState(value:Bool):Bool
	{
		value = super.setMutedState(value);

		this.sound.muted = value;

		return value;
	}

	private override function setPausedState(value:Bool):Bool
	{
		value = super.setPausedState(value);

		if (value)
			this.sound.pause();
		else if (this.isPlaying)
			this.sound.play();

		return value;
	}

	private override function setTrueVolume(value:Float):Float
	{
		if (this.trueVolume != value)
		{
			value = super.setTrueVolume(value);

			this.sound.volume = value;
		}

		return value;
	}
}
