package titanium_reindeer.assets;

interface ILoadable
{
	public function load():Void;
	public function getProgress():Float;
	public function isLoaded():Float;
}
