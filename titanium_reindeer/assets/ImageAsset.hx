package titanium_reindeer.assets;

import js.html.Image;

class ImageAsset implements IAsset
{
	public var path(default, null):String;

	public var image(default, null):

	public function new(path:String)
	{
		this.path = path;
		this.isLoaded = false;
		this.progress = 0;
		this.total = 1;


		this.image = new Image();
	}

	public function load()
	{
		this.image.onload = function () {
			this.isLoaded = true;
			this.progress = 1;
		};

		/* *
		this.image.onprogess
		/* */

		this.image.src = this.path;
	}

	public function getProgress():Float
	{
		return this.progress;
	}

	public function getTotal():Int
	{
		return this.total;
	}
}
