package titanium_reindeer.core;

interface IWatchable<T>
{
	public var value(default, null):T;

	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void;
}
