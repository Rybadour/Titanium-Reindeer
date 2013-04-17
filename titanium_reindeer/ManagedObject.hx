package titanium_reindeer;

class ManagedObject
{
	public var id(default, null):Int;

	public var manager(default, null):ObjectManager;
	public function setManager(manager:ObjectManager):Void
	{
		if (this.manager == null)
		{
			this.manager = manager;
			this.id = manager.getNextId();

			for (func in this.registeredManagerSetEvents)
			{
				func();
			}
		}
	}
	
	public var toBeDestroyed(default, null):Bool;

	private var registeredManagerSetEvents:Array<Void -> Void>;
	public function registerManagerSetFunc(func:Void -> Void):Void
	{
		if (func != null)
			this.registeredManagerSetEvents.push(func);
	}
	public function unregisterManagerSetFunc(func:Void -> Void):Void
	{
		if (func == null)
			return;

		for (i in 0...this.registeredManagerSetEvents.length)
		{
			// A pretty neat way of ensuring that i doesn't skip over the next element if a found method was spliced
			// because indexes are then moved down
			while (i < this.registeredManagerSetEvents.length)
			{
				if (Reflect.compareMethods(this.registeredManagerSetEvents[i], func))
					this.registeredManagerSetEvents.splice(i, 1);
				else
					break;
			}
		}
	}

	public function new()
	{
		this.registeredManagerSetEvents = new Array();
	}

	public function remove():Void
	{
	}

	public function destroy():Void
	{
		this.toBeDestroyed = true;
	}

	// Called when the object is properly removed from the manager
	public function finalDestroy():Void
	{
		this.manager = null;

		for (i in 0...this.registeredManagerSetEvents.length)
		{
			this.registeredManagerSetEvents.splice(0, 1);
		}
		this.registeredManagerSetEvents = null;
	}
}
