package titanium_reindeer.assets;

class AssetLoader implements ILoadable
{
	public var assets(default, null):Array<Asset>;
	private var unloadedAssets:Array<Asset>;

	public function new(assets:Array<Asset>)
	{
		this.unloadedAssets = assets.copy();
		this.assets = new Array();
	}

	public function load():Void
	{
		this.updateProgress();

		for (asset in this.unloadedAssets)
			asset.load();
	}

	public function getProgress()
	{
		if (this._isLoaded())
		{
			return 1;
		}
		else
		{
			// For now we assume that every asset has a total of 1
			var total = this.assets.length + this.unloadedAssets.length;
		
			this.updateProgress();

			// this.assets.length may have changed but total stays the same
			var progress = this.assets.length;

			return progress/total;
		}
	}

	public function isLoaded()
	{
		this.updateProgress();

		return this._isLoaded();
	}

	private function _isLoaded()
	{
		return this.unloadedAssets.length == 0;
	}

	private function updateProgress()
	{
		if (!this._isLoaded())
		{
			var assets = this.unloadedAssets.copy();
			for (asset in assets)
			{
				if (asset.isLoaded())
					this.assets.push(asset);
				else
					this.unloadedAssets.push(asset);
			}
		}
	}
}
