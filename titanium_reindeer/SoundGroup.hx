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

	public function new(soundManager:SoundManager, numChannels:Int)
	{
		super();

		this.soundManager = soundManager;
		this.soundManager.addSoundGroup(this);

		this.soundChannels = new Array();
		this.lastChannelUsed = -1;

		this.numChannels = numChannels;
	}
}
