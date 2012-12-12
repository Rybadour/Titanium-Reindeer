package titanium_reindeer;

class PrimitiveWatcher<T> extends Watcher<T>
{
	public function new(value:T)
	{
		var equals:T -> T -> Bool = function (a:T, b:T)
		{
			return a == b;
		};

		super(value, function (a:T, b:T):Bool { return a == b; });
	}
}
