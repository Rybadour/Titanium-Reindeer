package titanium_reindeer.ui;

class UIMargin
{
	public static function sides(topBot:Int, leftRight:Int):UIMargin
	{
		return new UIMargin(topBot, leftRight, topBot, leftRight);
	}

	public static function all(margin:Int):UIMargin
	{
		return new UIMargin(margin, margin, margin, margin);
	}

	public var top:Int;
	public var right:Int;
	public var bottom:Int;
	public var left:Int;

	public function new(top:Int, right:Int, bottom:Int, left:Int)
	{
		this.top = top;
		this.right = right;
		this.bottom = bottom;
		this.left = left;
	}
}
