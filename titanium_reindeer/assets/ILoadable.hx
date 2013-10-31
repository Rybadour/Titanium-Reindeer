package titanium_reindeer.assets;

interface ILoadable
{
	public function load():Void;
	public function isLoaded():Bool;
	public function getProgress():Float;
	public function getSize():Int;
}
