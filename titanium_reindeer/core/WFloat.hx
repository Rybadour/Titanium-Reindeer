package titanium_reindeer.core;

class WFloat implements IWatchable
{
	private var changeBinds:Array<Void -> Void>;
	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void
	{
		this.changeBinds.push(func);
		return func;
	}

	public var value(default, setValue):Float;
	public function setValue(value:Float):Float
	{
		if (this.value != value)
		{
			this.value = value;
			this.callOnChange();
		}

		return this.value;
	}

	public function new(value:Float)
	{
		this.value = value;

		this.changeBinds = new Array();
	}

	private function callOnChange():Void
	{
		for (func in this.changeBinds)
			func();
	}
}
