package titanium_reindeer.core;

class BaseRelation<Result> implements IWatchable<Result>
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

class Relation<A, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> Result;
	private var a:IWatchable<A>;

	public function new(a:IWatchable<A>, transformFunc:A -> Result)
	{
		super();

		this.changeBinds = new Array();
		this.transformFunc = transformFunc;

		this.a = a;
		this.a.onChange = dependentChanged;
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value) );
	}
}

class Relation2<A, B, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> B -> Result;
	private var a:IWatchable<A>;
	private var b:IWatchable<B>;

	public function new(a:IWatchable<A>, b:IWatchable<B>, transformFunc:A -> B -> Result)
	{
		super();

		this.changeBinds = new Array();
		this.transformFunc = transformFunc;

		this.a = a;
		this.a.onChange = dependentChanged;

		this.b = b;
		this.b.onChange = dependentChanged;
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value, b.value) );
	}
}

class Relation3<A, B, C, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> B -> C -> Result;
	private var a:IWatchable<A>;
	private var b:IWatchable<B>;
	private var c:IWatchable<C>;

	public function new(a:IWatchable<A>, b:IWatchable<B>, c:IWatchable<C>, transformFunc:A -> B -> C -> Result)
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
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value, b.value, c.value) );
	}
}

class Relation4<A, B, C, D, Result> extends BaseRelation<Result>
{
	private var transformFunc:A -> B -> C -> D -> Result;
	private var a:IWatchable<A>;
	private var b:IWatchable<B>;
	private var c:IWatchable<C>;
	private var d:IWatchable<D>;

	public function new(a:IWatchable<A>, b:IWatchable<B>, c:IWatchable<C>, d:IWatchable<D>, transformFunc:A -> B -> C -> D -> Result)
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
	}

	private function dependentChanged():Void
	{
		this.setValue( this.transformFunc(a.value, b.value, c.value, d.value) );
	}
}
