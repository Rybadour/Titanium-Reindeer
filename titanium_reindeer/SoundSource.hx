package titanium_reindeer;

import js.Dom;

class SoundSource extends SoundBase
{
	public var sound(default, null):Dynamic;

	public var isLoaded(default, null):Bool;

	private var loadedFunctions:List<Event -> Void>;

	public function new(filePath:String)
	{
		this.isLoaded = false;
		untyped
		{
			__js__("this.sound = new Audio()");
			this.sound.addEventListener("canplaythrough", this.soundLoaded, true);
			this.sound.src = filePath;
			this.sound.load();
		}
	}

	private function soundLoaded(event:Event):Void
	{
		if (this.sound == null)
			return;

		this.isLoaded = true;

		if (loadedFunctions != null)
		{
			for (func in loadedFunctions)
				func(event);

			loadedFunctions.clear();
			loadedFunctions = null;
		}
	}

	public function registerLoadEvent(cb:Event -> Void):Void
	{
		if (this.isLoaded)
			return;

		if (loadedFunctions == null)
			loadedFunctions = new List();

		loadedFunctions.push(cb);
	}

	public function identify():String
	{
		return "SoundSource("+sound.src+");";
	}

	public function destroy():Void
	{
		this.isLoaded = false;
		this.sound = null;

		if (loadedFunctions != null)
		{
			loadedFunctions.clear();
			loadedFunctions = null;
		}
	}
}
