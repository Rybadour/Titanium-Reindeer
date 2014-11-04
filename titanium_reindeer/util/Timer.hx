package titanium_reindeer.util;

class Timer
{
	public var elapsedMs:Int;

	public var elapsedCallback:Int -> Void;
	public var callbackThreshold:Int;
	
	public function new()
	{
		this.restart();
	}

	public function restart()
	{
		this.elapsedMs = 0;
	}

	public function update(msTimeStep):Void
	{
		this.elapsedMs += msTimeStep;

		if (this.elapsedCallback != null && this.callbackThreshold <= this.elapsedMs)
		{
			this.elapsedCallback(this.elapsedMs);
		}
	}

	public function callbackAtElapsed(callback:Int -> Void, elapsed:Int)
	{
		this.elapsedCallback = callback;
		this.callbackThreshold = elapsed;
	}
}
