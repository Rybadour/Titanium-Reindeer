package titanium_reindeer.assets;

interface IAsset
{
	public var path(default, null):String;

	public function load():Void;
	public function getProgress():Float;
	public function isLoaded():Bool;
}
