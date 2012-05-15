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

	public var isMuted(getIsMuted, never):Bool;
	public function getIsMuted():Bool
	{
		return this.lockingMute || (!this.muteLocked && this.mutedState);
	}

	public var isTrulyMuted(getIsTrulyMuted, never):Bool;
	public function getIsTrulyMuted():Bool { return this.mutedState; }

	private var mutedState(default, setMutedState):Bool;
	private function setMutedState(value:Bool):Bool
	{
		this.mutedState = value;
		return value;
	}

	public var isPaused(getIsPaused, never):Bool;
	public function getIsPaused():Bool
	{
		return this.lockingPause || (!this.pauseLocked && this.pausedState);
	}

	public var isTrulyPaused(getIsTrulyPaused, never):Bool;
	public function getIsTrulyPaused():Bool { return this.pausedState; }

	private var pausedState(default, setPausedState):Bool;
	private function setPausedState(value:Bool):Bool
	{
		this.pausedState = value;
		return value;
	}

	// These will be true if this object is locking it's subordinates
	public var lockingMute(default, null):Bool;
	public var lockingPause(default, null):Bool;

	// These will be true when a scene or game has requested a lock on these properties
	public var muteLocked(default, null):Bool;
	public var pauseLocked(default, null):Bool;

	public function new()
	{
		this.volumeModifier = 1.0;
		this.volume = 1.0;

		this.mutedState = false;
		this.pausedState = false;
		this.lockingMute = false;
		this.lockingPause = false;
		this.muteLocked = false;
		this.pauseLocked = false;
	}

	public function mute(lock:Bool = true):Void
	{
		// Don't bother if we are already muted, unless we now locking
		if ((this.mutedState && !lock) || this.lockingMute)
			return;

		this.mutedState = true;
		this.lockingMute = lock;

		if (lock)
			this.propagateCall("lockedMute", []);
		else
			this.propagateCall("mute", [false]);
	}

	public function unmute():Void
	{
		if (!this.mutedState)
			return;

		if (this.muteLocked)
		{
			this.lockingMute = false;
			return;
		}

		this.mutedState = false;
		if (this.lockingMute)
		{
			this.propagateCall("lockedUnmute", []);
			this.lockingMute = false;
		}
		else
			this.propagateCall("unmute", []);
	}
	
	public function pause(lock:Bool = true):Void
	{
		// Don't bother if we are already paused, unless we now locking
		if ((this.pausedState && !lock) || this.lockingPause)
			return;

		this.pausedState = true;
		this.lockingPause = lock;

		if (lock)
			this.propagateCall("lockedPause", []);
		else
			this.propagateCall("pause", [false]);
	}

	public function unpause():Void
	{
		if (!this.pausedState)
			return;

		if (this.pauseLocked)
		{
			this.lockingPause = false;
			return;
		}

		this.pausedState = false;
		if (this.lockingPause)
		{
			this.propagateCall("lockedUnpause", []);
			this.lockingPause = false;
		}
		else
			this.propagateCall("unpause", []);
	}

	private function lockedMute():Void
	{
		this.muteLocked = true;
		if (!this.lockingMute)
		{
			this.mutedState = true;
			this.propagateCall("lockedMute", []);
		}
	}

	private function lockedUnmute():Void
	{
		this.muteLocked = false;
		if (!this.lockingMute)
		{
			this.mutedState = false;
			this.propagateCall("lockedUnmute", []);
		}
	}

	private function lockedPause():Void
	{
		this.pauseLocked = true;
		if (!this.lockingPause)
		{
			this.pausedState = true;
			this.propagateCall("lockedPause", []);
		}
	}

	private function lockedUnpause():Void
	{
		this.pauseLocked = false;
		if (!this.lockingPause)
		{
			this.pausedState = false;
			this.propagateCall("lockedUnpause", []);
		}
	}

	private function updateTrueVolume():Void
	{
		this.setTrueVolume(this.volume * this.volumeModifier);

		this.propagateCall("setVolumeModifier", [this.trueVolume]);
	}

	private function propagateCall(methodName:String, params:Array<Dynamic>):Void
	{
	}
}
