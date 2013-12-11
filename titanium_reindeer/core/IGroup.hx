package titanium_reindeer.core;

interface IGroup<T> implements IHasIdProvider
{
	public var idProvider(default, null):IdProvider;
	public var name(default, null):String;

	public function get(id:Int):T;
	public function add(id:Int, object:T):Void;
	public function remove(id:Int):Void;
}
