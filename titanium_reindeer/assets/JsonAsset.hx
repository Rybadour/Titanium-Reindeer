package titanium_reindeer.assets;

import haxe.Json;

/**
 * A simple asset used to retrieve a JSON document from the specified url.
 */
class JsonAsset extends HttpAsset
{
	public var json:String;

	public function new(url:String)
	{
		super(url, HttpAssetType.Json);
	}

	private override function _onLoad(event)
	{
		super._onLoad(event);

        this.json = this.data;
	}
}
