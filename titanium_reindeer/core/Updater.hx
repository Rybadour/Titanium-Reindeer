package titanium_reindeer.core;

class Updater
{
	public var isPaused(default, null):Bool;

	private var preFunc:Int -> Void;
	private var func:Int -> Void;
	private var postFunc:Int -> Void;

	public function new(preFunc:Int -> Void, func:Int -> Void, postFunc:Int -> Void)
	{
		this.isPaused = false;

		this.preFunc = preFunc;
		this.func = func;
		this.postFunc = postFunc;
	}

	public function pause():Void
	{
		this.isPaused = true;
	}
	public function unpause():Void
	{
		this.isPaused = false;
	}

	public function preUpdate(msTimeStep:Int):Void
	{
		if (!this.isPaused && this.preFunc != null)
			this.preFunc(msTimeStep);
	}
	public function update(msTimeStep:Int):Void
	{
		if (!this.isPaused && this.func != null)
			this.func(msTimeStep);
	}
	public function postUpdate(msTimeStep:Int):Void
	{
		if (!this.isPaused && this.postFunc != null)
			this.postFunc(msTimeStep);
	}
}
