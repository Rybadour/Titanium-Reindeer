package titanium_reindeer.core;

class Watcher<T> implements IWatchable<T>
{
	public var value(default, setValue):T;
	private function setValue(value:T):T
	{
		if ( this.value == null || !this.equalsFunc(this.value, value) )
		{
			this.value = value;

			for (func in this.changeBinds)
				func();
		}

		return this.value;
	}

	private var equalsFunc:T -> T -> Bool;

	private var changeBinds:Array<Void -> Void>;
	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void
	{
		this.changeBinds.push(func);
		return func;
	}

	public function new(value:T, equalsFunc:T -> T -> Bool)
	{
		this.changeBinds = new Array();
		this.equalsFunc = equalsFunc;
		this.value = value;
		if (this.equalsFunc == null)
			this.equalsFunc = function (a:T, b:T):Bool
			{
				return a == b;
			}
	}
}
