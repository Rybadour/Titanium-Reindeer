package titanium_reindeer;

class WatchedVector2 extends Vector2
{
	override private function setX(value:Float):Float
	{
		if (value != mX && this.changeCallback != null)
		{
			this.changeCallback();
		}

		super.setX(value);

		return mX;
	}

	override private function setY(value:Float):Float
	{
		if (value != y && this.changeCallback != null)
		{
			this.changeCallback();
		}

		super.setY(value);

		return mY;
	}

	public function setVector2(value:Vector2):Vector2
	{
		if (value != null)
		{
			if (value.x != x || value.y != y)
			{
				mX = value.x;
				mY = value.y;
				this.changeCallback();
			}
		}

		return this;
	}

	private var changeCallback:Void -> Void;

	public function new(x:Float, y:Float, changeCallback:Void -> Void)
	{
		this.changeCallback = changeCallback;

		super(x, y);
	}

	public function destroy():Void
	{
		this.changeCallback = null;
	}
}
