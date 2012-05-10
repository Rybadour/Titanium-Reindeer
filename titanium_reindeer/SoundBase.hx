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
		}

		return this.volume;
	}

	private var modifiedVolume(default, setModifiedVolume):Float;
	private function setModifiedVolume(value:Float):Float
	{
		if (this.modifiedVolume != value)
		{
			if (value > 1.0)
				value = 1.0;
			else if (value < 0.0)
				value = 0.0;

			this.modifiedVolume = value;
		}

		return this.modifiedVolume;
	}

	public var isMuted(default, null):Bool;
	public var isPaused(default, null):Bool;

	public function new()
	{
		super();

		this.modifiedVolume = 1.0;
		this.volume = 1.0;
		this.isMuted = false;
		this.isPaused = false;
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
