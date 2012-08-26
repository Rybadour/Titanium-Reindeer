package titanium_reindeer.core;

interface IGroup<T:IHasId> implements IHasIdProvider
{
	public var idProvider(default, null):IdProvider;
	public var name(default, null):String;

	public function get(id:Int):T;
	public function add(object:T):Void;
	public function remove(object:T):Void;
}
