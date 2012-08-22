package titanium_reindeer.core;

interface IProvidesIds
{
	private var lastId:Int;
	private var oldAvailableIds:Array<Int>;

	public function requestId():Int;
	public function freeUpId(object:IHasId):Void;
}
