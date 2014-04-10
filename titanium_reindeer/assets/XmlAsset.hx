package titanium_reindeer.assets;

/**
 * The base class of all assets loaded using an HttpRequest.
 * Pretty much all files other than Images will use this.
 * A simple XmlHttpRequest is made to get the file from the specified url.
 */
class XmlAsset extends HttpAsset
{
	public var xml:Xml;

	public function new(url:String)
	{
		super(url, HttpAssetType.Xml);
	}
}
