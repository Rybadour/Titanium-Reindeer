package titanium_reindeer.assets;

/**
 * Allows chaining assets that are dependent on each other so you can do further processing or
 * dynamic loading.
 */
class AssetDependency<A:ILoadable, B:ILoadable> implements ILoadable
{
	public var starting:A;
	public var resulting:B;
	public var processor:A -> B;

	public function new(startingAsset:A, processor:A -> B)
	{
		this.starting = startingAsset;
		this.processor = processor;
	}

	public function load():Void
	{
		this.starting.load();
	}

	private function maybeProcess():Void
	{
		if (this.resulting == null && this.starting.isLoaded())
		{
			this.resulting = this.processor(this.starting);
			this.resulting.load();
		}
	}

	public function update(msTimeStep:Int):Void
	{
		this.maybeProcess();
	}

	public function isLoaded():Bool
	{
		this.maybeProcess();
		return (this.starting.isLoaded() && (this.resulting != null && this.resulting.isLoaded()));
	}

	public function getProgress():Float
	{
		this.maybeProcess();
		function getProg(asset:ILoadable) {
			return (asset == null ? 0 : asset.getProgress() / 2);
		}
		return getProg(this.starting) + getProg(this.resulting);
	}

	public function getSize():Int
	{
		this.maybeProcess();
		function getSize(asset:ILoadable) {
			return (asset == null ? 1 : asset.getSize());
		}
		return getSize(this.starting) + getSize(this.resulting);
	}
}
