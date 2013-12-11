package titanium_reindeer.core;

class BaseRelation<Result> implements IWatchable
{
	public var value(default, null):Result;
	private function setValue(value:Result):Void
	{
		this.value = value;
		
		for (func in this.changeBinds)
			func();
	}

	private var changeBinds:Array<Void -> Void>;
	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void
	{
		this.changeBinds.push(func);
		return func;
	}

	public function new()
	{
		this.changeBinds = new Array();
	}
}

class Relation<A:IWatchable, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> Result;
	private var a:A;

	public function new(a:A, transformFunc:A -> Result)
	{
		super();

		this.transformFunc = transformFunc;

		this.a = a;
		this.a.onChange = dependentChanged;

		this.dependentChanged();
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value) );
	}
}

class Relation2<A:IWatchable, B:IWatchable, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> B -> Result;
	private var a:A;
	private var b:B;

	public function new(a:A, b:B, transformFunc:A -> B -> Result)
	{
		super();

		this.changeBinds = new Array();
		this.transformFunc = transformFunc;

		this.a = a;
		this.a.onChange = dependentChanged;

		this.b = b;
		this.b.onChange = dependentChanged;

		this.dependentChanged();
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value, b.value) );
	}
}

class Relation3<A:IWatchable, B:IWatchable, C:IWatchable, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> B -> C -> Result;
	private var a:A;
	private var b:B;
	private var c:C;

	public function new(a:A, b:B, c:C, transformFunc:A -> B -> C -> Result)
	{
		super();

		this.changeBinds = new Array();
		this.transformFunc = transformFunc;

		this.a = a;
		this.a.onChange = dependentChanged;

		this.b = b;
		this.b.onChange = dependentChanged;

		this.c = c;
		this.c.onChange = dependentChanged;

		this.dependentChanged();
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value, b.value, c.value) );
	}
}

class Relation4<A:IWatchable, B:IWatchable, C:IWatchable, D:IWatchable, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> B -> C -> D -> Result;
	private var a:A;
	private var b:B;
	private var c:C;
	private var d:D;

	public function new(a:A, b:B, c:C, d:D, transformFunc:A -> B -> C -> D -> Result)
	{
		super();

		this.changeBinds = new Array();
		this.transformFunc = transformFunc;

		this.a = a;
		this.a.onChange = dependentChanged;

		this.b = b;
		this.b.onChange = dependentChanged;

		this.c = c;
		this.c.onChange = dependentChanged;

		this.d = d;
		this.d.onChange = dependentChanged;

		this.dependentChanged();
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value, b.value, c.value, d.value) );
	}
}
