package titanium_reindeer;

class SoundManager extends SoundBase
{
	public function new()
	{
		this.maxSoundChannels = 32;
		this.volume = 1;
		this.isMuted = false;
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
