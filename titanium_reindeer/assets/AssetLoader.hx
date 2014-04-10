package titanium_reindeer.assets;

class AssetLoader implements ILoadable
{
	public var assets(default, null):Array<ILoadable>;
	private var unloadedAssets:Array<ILoadable>;

	public function new(?assets:Array<ILoadable>)
	{
		this.unloadedAssets = (assets == null ? [] : assets.copy());
		this.assets = new Array();
	}
	
	public function addAssets(assets:Array<ILoadable>)
	{
		this.unloadedAssets = this.unloadedAssets.concat(assets);
	}

	public function load():Void
	{
		this.updateProgress();

		for (asset in this.unloadedAssets)
			asset.load();
	}

	public function getProgress():Float
	{
		if (this._isLoaded())
		{
			return 1;
		}
		else
		{
			this.updateProgress();

			return this.getLoadedSize() / this.getSize();
		}
	}

	public function getLoadedSize():Int
	{
		var total = 0;
		for (asset in this.assets)
			total += asset.getSize();
		return total;
	}

	public function getUnloadedSize():Int
	{
		var total = 0;
		for (asset in this.unloadedAssets)
			total += asset.getSize();
		return total;
	}

	public function getSize():Int
	{
		return this.getLoadedSize() + this.getUnloadedSize();
	}

	public function isLoaded():Bool
	{
		this.updateProgress();

		return this._isLoaded();
	}

	private function _isLoaded():Bool
	{
		return this.unloadedAssets.length == 0;
	}

	private function updateProgress():Void
	{
		if (!this._isLoaded())
		{
			var i = 0;
			while (i < this.unloadedAssets.length)
			{
				var asset = this.unloadedAssets[i];
				if (asset.isLoaded())
				{
					this.assets.push(asset);

					this.unloadedAssets.splice(i, 1);
				}
				else
				{
					i++;
				}
			}
		}
	}
}
