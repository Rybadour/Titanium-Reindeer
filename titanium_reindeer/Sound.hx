package titanium_reindeer;

class Sound extends SoundBase
{
	public var soundSource(default, null):SoundSource;
	public var sound(default, null):Dynamic;

	public function new(soundSource:SoundSource)
	{
		super();

		this.soundSource = soundSource;
		untyped
		{
			__js__("this.sound = new Audio()");
			this.sound.src = this.soundSource.sound.src;
			this.sound.load();
		}
	}

	public function play():Void
	{
		this.sound.play();
	}

	private override function setTrueVolume(value:Float):Float
	{
		if (this.trueVolume != value)
		{
			super.setTrueVolume(value);

			this.sound.volume = value;
		}
	}
}
