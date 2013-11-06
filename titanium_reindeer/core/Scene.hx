package titanium_reindeer.core;

class Scene 
{
	public var isPaused(default, null):Bool;

	public function new()
	{
		this.isPaused = false;
	}

	public function update(msTimeStep:Int):Void
	{
		if ( ! this.isPaused)
		{
			this.preUpdate(msTimeStep);
			this._update(msTimeStep);
			this.postUpdate(msTimeStep);
		}
	}

	public function pause():Void
	{
		this.isPaused = true;
	}

	public function unpause():Void
	{
		this.isPaused = false;
	}

	// Real-time updates
	private function preUpdate(msTimeStep:Int):Void
	{
	}

	private function _update(msTimeStep:Int):Void
	{
	}

	private function postUpdate(msTimeStep:Int):Void
	{
	}
}
