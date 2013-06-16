package titanium_reindeer.core;

interface IWatchable
{
	public var onChange(never, bindOnChange):Void -> Void;
	public function bindOnChange(func:Void -> Void):Void -> Void;
}
