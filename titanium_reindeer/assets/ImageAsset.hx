package titanium_reindeer.assets;

import js.html.Image;

class ImageAsset implements IAsset
{
	public var path:String;
	private var _isLoaded:Bool;

	public var image(default, null):Image;

	public function new(path:String)
	{
		this.path = path;
		this._isLoaded = false;

		this.image = new Image();
	}

	public function isLoaded():Bool
	{
		return this._isLoaded;
	}

	public function load():Void
	{
		this.image.onload = function (e) {
			this._isLoaded = true;
		};

		/* *
		this.image.onprogess
		/* */

		this.image.src = this.path;
	}

	public function getProgress():Float
	{
		return (this._isLoaded ? 1 : 0);
	}

	public function getSize():Int
	{
		return 1;
	}
}
