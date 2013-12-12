package titanium_reindeer.core;

/**
 * The Scene class is the base class for something which needs to be updated and paused. Each call 
 * to update the scene is a step in time. A game instance is usually responsible for propogating the
 * initial time step update.
 */
class Scene 
{
	// Flag for the paused state of the Scene
	public var isPaused(default, null):Bool;

	public function new()
	{
		this.isPaused = false;
	}

	/**
	 * A call to update causes the frame to simulate one time step
	 */
	public function update(msTimeStep:Int):Void
	{
		if ( !this.isPaused )
		{
			this.preUpdate(msTimeStep);
			this._update(msTimeStep);
			this.postUpdate(msTimeStep);
		}
	}

	/**
	 * Set the scene to the paused state.
	 * This prevents time steps from taking place.
	 */
	public function pause():Void
	{
		this.isPaused = true;
	}

	/**
	 * Set the scene to the unpaused state.
	 * This allows time steps to take place.
	 */
	public function unpause():Void
	{
		this.isPaused = false;
	}

	/**
	 * These functions are designed to be overridden by the sub-class.
	 * They are called automatically when update() is called, but only if the scene is unpaused.
	 */
	private function preUpdate(msTimeStep:Int):Void {}
	private function _update(msTimeStep:Int):Void {}
	private function postUpdate(msTimeStep:Int):Void {}
}
