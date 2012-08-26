package titanium_reindeer.core;

class IdProvider
{
	private var lastId:Int;
	private var oldAvailableIds:Array<Int>;

	public function new()
	{
		this.lastId = 0;
		this.oldAvailableIds = new Array();
	}

	public function requestId():Int
	{
		if (this.oldAvailableIds.length > 0)
			return this.oldAvailableIds.pop();

		return this.lastId++;
	}

	public function freeUpId(object:IHasId):Void
	{
		if (this.lastId == object.id + 1)
			this.lastId--;
		else
			this.oldAvailableIds.push(object.id);
	}
}
