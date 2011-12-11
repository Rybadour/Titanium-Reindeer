package titanium_reindeer;

class PropertyEffect
{
	private var effectTimer:Timer;

	private var object:Dynamic;
	private var property:String;

	private var changeAmount:Float;
	private var iterations:Int;

	public function new(object:Dynamic, property:String, duration:Int, fromAmount:Float, toAmount:Float)
	{
		effectTimer = new Timer();
		
	}

	public function destroy():Void
	{
		effectTimer = null;
		object = null;
	}
}
