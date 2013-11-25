package titanium_reindeer.ui;

enum UIAlignX
{
	Left;
	Right;
	Center;
}

enum UIAlignY
{
	Top;
	Bottom;
	Center;
}

class UIAlignment
{
	public var xAlign:UIAlignX;
	public var yAlign:UIAlignY;

	public function new(xAlign:UIAlignX, yAlign:UIAlignY)
	{
		this.xAlign = xAlign;
		this.yAlign = yAlign;
	}

	public function getFromSize(width:Int, height:Int):Vector2
	{
		var x = switch (this.xAlign)
		{
			case Left: 0;
			case Right: width;
			case Center: Math.round(width/2);
		}

		var y = switch (this.yAlign)
		{
			case Top: 0;
			case Bottom: height;
			case Center: Math.round(height/2);
		}

		return new Vector2(x, y);
	}
}
