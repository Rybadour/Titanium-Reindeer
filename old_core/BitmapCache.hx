package titanium_reindeer;

import js.Dom;

class BitmapCache
{
	private var cachedBitmaps:Hash<ImageSource>;

	public function new()
	{
		this.cachedBitmaps = new Hash();
	}

	public function exists(identifier:String):Bool
	{
		return this.cachedBitmaps.exists(identifier);
	}

	public function set(identifier:String, bitmap:ImageSource):Bool
	{
		if ( !this.cachedBitmaps.exists(identifier) )
		{
			this.cachedBitmaps.set(identifier, bitmap);
			return true;
		}

		return false;
	}

	public function get(identifier:String):ImageSource
	{
		return this.cachedBitmaps.get(identifier);
	}

	public function remove(identifier:String):Bool
	{
		return this.cachedBitmaps.remove(identifier);
	}

	public function destroy():Void
	{
		for (image in this.cachedBitmaps)
			image.destroy();

		this.cachedBitmaps = null;
	}
}
