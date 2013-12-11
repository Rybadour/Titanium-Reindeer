package titanium_reindeer;

class EventBinder
{
	private var eventBinds:Map<String, Array<Dynamic>>;

	public function new(eventNames:Array<String>)
	{
		this.eventBinds = new Map();
		for (name in eventNames)
		{
			this.eventBinds.set(name, []);
		}
	}

	public function bindFunc(eventName:String, func:Dynamic):Void
	{
		if (func == null)
			return;

		if ( this.eventBinds.exists(eventName) )
			this.eventBinds.get(eventName).push(func);
		else
			this.eventBinds.set(eventName, [func]);
	}

	public function getBinds(eventName:String):Array<Dynamic>
	{
		if (this.eventBinds.exists(eventName))
			return this.eventBinds.get(eventName);
		else
		{
			this.eventBinds.set(eventName, []);
			return [];
		}
	}

	public function callBindsVoid(eventName:String):Void
	{
		for (func in this.getBinds(eventName))
			func();
	}

	public function callBinds1Arg(eventName:String, arg1:Dynamic):Void
	{
		for (func in this.getBinds(eventName))
			func(arg1);
	}

	public function callBinds2Arg(eventName:String, arg1:Dynamic, arg2:Dynamic):Void
	{
		for (func in this.getBinds(eventName))
			func(arg1, arg2);
	}

	public function callBinds3Arg(eventName:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic):Void
	{
		for (func in this.getBinds(eventName))
			func(arg1, arg2, arg3);
	}

	public function unbindFunc(eventName:String, func:Dynamic):Void
	{
		if ( func == null || !this.eventBinds.exists(eventName) )
			return;

		var binds:Array<Dynamic> = this.eventBinds.get(eventName);
		for (i in 0...binds.length)
		{
			if (Reflect.compareMethods(binds[i], func))
			{
				binds.splice(i, 1);
				break;
			}
		}
	}

	public function destroy():Void
	{
		for (name in this.eventBinds.keys())
		{
			this.eventBinds.set(name, null);
			this.eventBinds.remove(name);
		}
		this.eventBinds = null;
	}
}
