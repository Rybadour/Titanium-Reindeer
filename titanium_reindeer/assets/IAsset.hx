package titanium_reindeer.assets;

interface Asset
{
	public var path(default, null):String;

	public function load():Void;
	public function getProgress():Float;
	public function isLoaded():Float;
}
