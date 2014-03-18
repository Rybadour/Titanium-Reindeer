package titanium_reindeer.assets;

import js.html.XmlHttpRequest;

/**
 * The base class of all assets loaded using an HttpRequest.
 * Pretty much all files other than Images will use this.
 * A simple XmlHttpRequest is made to get the file from the specified url.
 */
class HttpAsset implements IAsset
{
	// The URL of the file. It may be relative to some loader (with a root path specified).
	public var url:String;
	
	// The contents of the file (undecoded)
	public var data(default, null):String;

	// The expected type of the file regardless of extension.
	public var type(default, null):HttpAssetType;


	// The state of the file contents being loaded
	private var _isLoaded:Bool;

	// The request used to retrieve the file
	private var _request:XmlHttpRequest;

	// The absolute size of the file.
	private var _size:Int;

	// The size of the file loaded so far
	private var _loadedSize:Int;

	public function new(url:String, type:HttpAssetType)
	{
		this.url = url;
		this.type = type;

		this._isLoaded = false;
		this._size = 0;
		this._loadedSize = 0;
	}

	/**
	 * Simple getter to ask if the file's contents are loaded.
	 */
	public function isLoaded():Bool
	{
		return this._isLoaded;
	}

	/**
	 * Causes the asset to retrieve the file's contents.
	 */
	public function load():Void
	{
		this._request = new XmlHttpRequest();

		// Set the expected type of file
		if (this._request.overrideMimeType) {
			switch (this.type)
			{
				case Json:
					this._request.overrideMimeType('application/json');

				case Xml:
					this._request.overrideMimeType('text/xml');
			}
		}

		this._request.addEventListener("progress", this._onProgress, false);
		this._request.addEventListener("load", this._onLoad, false);
		this._request.addEventListener("error", this._onError, false);
		this._request.addEventListener("abort", this._onAbort, false);

		this._request.open("GET", this.url, true);
		this._request.send();
	}

	public function getProgress():Float
	{
		if (this._size == 0)
			return (this._isLoaded ? 1 : 0);
		else
			return this._loadedSize / this._size);
	}

	public function getSize():Int
	{
		return this._size;
	}
	
	private function _onProgress(event:XmlHttpRequestProgressEvent)
	{
		// The haxe api differs from the HTML5 spec about how this event works
		this._size = event.totalSize;
		this._loadedSize = event.position;
	}
}
