package titanium_reindeer.assets;

class AssetLoader implements ILoadable
{
	private var isLoaded:Bool;
	public var assets(default, null):Array<Asset>;

	public function new(assets:Array<Asset>)
	{
		this.isLoaded = false;
		this.assets = assets.copy();
	}

	public function load():Void
	{
		var anyLoading:Bool = false;
		for (asset in this.assets)
		{
			if (!asset.isLoaded())
			{
				anyLoading = true;
				asset.load();
			}
		}

		this.isLoaded = !anyLoading;
	}

	public function getProgress()
	{
	}

	public function isLoaded()
	{
		return this.isLoaded;
	}
}
