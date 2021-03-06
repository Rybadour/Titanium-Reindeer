package titanium_reindeer.core;

/**
 * The Scene class is the base class for something which needs to be updated and paused. Each call 
 * to update the scene is a step in time. A game instance is usually responsible for propogating the
 * initial time step update.
 */
class Scene 
{
	/**
	 * Determines the paused state of the scene. If true it is designed not to update normally.
	 */
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
	 * This function is designed to be overridden by the sub-class.
	 * Automatically call when update() is called, but only if the scene is unpaused.
	 * preUpdate is called before _update.
	 */
	private function preUpdate(msTimeStep:Int):Void {}

	/**
	 * This function is designed to be overridden by the sub-class.
	 * Automatically call when update() is called, but only if the scene is unpaused.
	 * _update is called before postUpdate.
	 */
	private function _update(msTimeStep:Int):Void {}

	/**
	 * This function is designed to be overridden by the sub-class.
	 * Automatically call when update() is called, but only if the scene is unpaused.
	 * postUpdate is called after _update.
	 */
	private function postUpdate(msTimeStep:Int):Void {}
}
