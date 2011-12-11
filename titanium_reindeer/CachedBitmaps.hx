package titanium_reindeer;

import js.Dom;

class CachedBitmaps
{
	private var cachedBitmaps:TrieDict<ImageSource>;

	public function new()
	{
		this.cachedBitmaps = new TrieDict();
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
		var images:Array<ImageSource> = cachedBitmaps.getValues();
		for (image in images)
			image.destroy();

		this.cachedBitmaps.destroy();
		this.cachedBitmaps = null;
	}
}
