package titanium_reindeer;

import titanium_reindeer.core.IWatchable;

class WVector2 extends Vector2, implements IWatchable
{
	private var changeBinds:Array<Void -> Void>;
	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void
	{
		this.changeBinds.push(func);
		return func;
	}

	override private function setX(value:Float):Float
	{
		if (this.mX != value)
		{
			super.setX(value);
			this.callOnChange();
		}

		return this.mX;
	}

	override private function setY(value:Float):Float
	{
		if (this.mY != value)
		{
			super.setY(value);
			this.callOnChange();
		}

		return this.mY;
	}

	public function new(x:Float, y:Float)
	{
		super(x, y);

		this.changeBinds = new Array();
	}

	private function callOnChange():Void
	{
		for (func in this.changeBinds)
			func();
	}
}
