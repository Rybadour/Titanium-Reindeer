import titanium_reindeer.core.IProvidesIds;
import titanium_reindeer.core.IHasId;

class IdProvider implements IProvidesIds
{
	private var lastId:Int;
	private var oldAvailableIds:Array<Int>;

	public function requestId():Int
	{
		return this.lastId++;
	}

	public function freeUpId(object:IHasId):Void
	{
	}

	public function new()
	{
		this.lastId = 0;
	}
}
