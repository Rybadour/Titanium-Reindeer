package titanium_reindeer;

class SoundBase
{
	public var volume(default, setVolume):Float;
	private function setVolume(value:Float):Float
	{
		if (this.volume != value)
		{
			if (value > 1.0)
				value = 1.0;
			else if (value < 0.0)
				value = 0.0;

			this.volume = value;
			this.updateTrueVolume();
		}

		return this.volume;
	}

	private var volumeModifier(default, setVolumeModifier):Float;
	private function setVolumeModifier(value:Float):Float
	{
		if (this.volumeModifier != value)
		{
			if (value > 1.0)
				value = 1.0;
			else if (value < 0.0)
				value = 0.0;

			this.volumeModifier = value;
			this.updateTrueVolume();
		}

		return this.volumeModifier;
	}

	public var trueVolume(default, null):Float;
	private function setTrueVolume(value:Float):Float
	{
		if (this.trueVolume != value)
		{
			if (value > 1.0)
				value = 1.0;
			else if (value < 0.0)
				value = 0.0;

			this.trueVolume = value;
		}

		return this.trueVolume;
	}

	public var isMuted(default, null):Bool;
	public var isPaused(default, null):Bool;

	public function new()
	{
		super();

		this.volumeModifier = 1.0;
		this.volume = 1.0;
		this.isMuted = false;
		this.isPaused = false;
	}

	private function updateTrueVolume():Void
	{
		this.setTrueVolume(this.volume * this.volumeModifier);
	}

	public function mute():Void
	{
		this.isMuted = true;
	}

	public function unmute():Void
	{
		this.isMuted = false;
	}
	
	public function pause():Void
	{
		this.isPaused = true;
	}

	public function unpause():Void
	{
		this.isPaused = false;
	}
}
