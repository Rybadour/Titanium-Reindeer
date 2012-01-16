package titanium_reindeer;

class MouseExclusionRegion
{
	public var manager(default, null):MouseRegionManager;
	public var id(default, null):Int;
	private var dontUpdateManager:Bool;

	public var depth:Int;

	public var shape(default, setShape):Shape;
	private function setShape(value:Shape):Shape
	{
		if (value != this.shape && value != null)
		{
			this.shape = value;

			if (!this.dontUpdateManager)
				this.manager.updateExclusionRegionShape(this);
		}

		return this.shape;
	}

	public function new(manager:MouseRegionManager, id:Int, depth:Int, shape:Shape)
	{
		this.manager = manager;
		this.id = id;

		this.depth = depth;

		if (shape == null)
			throw "Error: MouseExclusionRegion must take a non-null shape!";

		this.dontUpdateManager = true;
		this.shape = shape;
		this.dontUpdateManager = false;
	}

	public function destroy():Void
	{
		if (this.manager != null)
		{
			this.manager.removeExclusionRegion(this);
			this.manager = null;
		}
	}
}
