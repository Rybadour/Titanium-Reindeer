package titanium_reindeer.core;

interface IGroup<T:IHasId>
{
	public var idProvider(default, null):IProvidesIds;
	public var name(default, null):String;

	public function get(id:Int):T;
	public function add(object:T):Void;
	public function remove(object:T):Void;

	public function update(msTimeStep:Int):Void;
}
