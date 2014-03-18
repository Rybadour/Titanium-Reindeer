package titanium_reindeer.assets;

class HttpLoader extends AssetLoader
{
	private var rootPath:String;
	private var uniqueAssets:Map<String, HttpAsset>;

	public function new(assets:Array<HttpAsset>, ?rootPath:String = '')
	{
		super([]);

		this.rootPath = rootPath;
		this.uniqueAssets = new Map();
		this.addAssets(assets);
	}

	public function addHttpAssets(assets:Array<HttpAsset>):Void
	{
		var newUniqueAssets = new Array();

		// Pick out unique assets
		for (asset in assets)
		{
			var url = rootPath + asset.url;
			if ( !this.uniqueAssets.exists(url) )
			{
				this.uniqueAssets.set(url, asset);
				asset.url = url;
				newUniqueAssets.push(asset);
			}	
		}

		// Only load unique image paths
		super.addHttpAssets(newUniqueAssets);
	}

	public function get(url:String):HttpAsset
	{
		return this.uniqueAssets.get(rootPath + url);
	}
}
