package titanium_reindeer.core;

class Watcher<T> implements IWatchable
{
	public var value(default, setValue):T;
	private function setValue(value:T):T
	{
		if (this.value != value)
		{
			this.value = value;

			for (func in this.changeBinds)
				func();
		}

		return this.value;
	}

	private var changeBinds:Array<Void -> Void>;
	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void
	{
		this.changeBinds.push(func);
		return func;
	}

	public function new(value:T)
	{
		this.changeBinds = new Array();
		this.value = value;
	}
}
