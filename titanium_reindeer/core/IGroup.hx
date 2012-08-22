package titanium_reindeer.core;

interface IGroup
{
	public var idProvider(default, null):IProvidesIds;
	public var name(default, null):String;

	public function update(msTimeStep:Int):Void;
}
