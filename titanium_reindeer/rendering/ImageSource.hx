package titanium_reindeer.rendering;

import js.Dom;

class ImageSource
{
	public var image(default, null):js.Image;
	public var width(default, null):Int;
	public var height(default, null):Int;

	public var isLoaded(default, null):Bool;

	private var loadedFunctions:List<Void -> Void>;

	public function new(path:String)
	{
		untyped
		{
			__js__("this.image = new Image();");
			this.image.onload = this.imageLoaded;
			this.image.src = path;
		}
	}

	private function imageLoaded(event:Event):Void
	{
		if (this.image == null)
			return;

		this.isLoaded = true;

		this.width = this.image.width;
		this.height = this.image.height;

		if (loadedFunctions != null)
		{
			for (func in loadedFunctions)
				func();

			loadedFunctions.clear();
			loadedFunctions = null;
		}
	}

	public function registerLoadEvent(cb:Void -> Void):Void
	{
		if (this.isLoaded)
			return;

		if (loadedFunctions == null)
			loadedFunctions = new List();

		loadedFunctions.push(cb);
	}

	public function identify():String
	{
		return "ImageSource("+image.src+","+width+","+height+");";
	}

	public function destroy():Void
	{
		this.isLoaded = false;
		this.image = null;

		if (loadedFunctions != null)
		{
			loadedFunctions.clear();
			loadedFunctions = null;
		}
	}
}
