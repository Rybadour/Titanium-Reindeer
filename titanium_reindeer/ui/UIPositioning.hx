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

class UIPositioning
{
	public var xAlign:UIAlignX;
	public var xOffset:Int;

	public var yAlign:UIAlignY;
	public var yOffset:Int;

	public function new(xAlign:UIAlignX, xOffset:Int, yAlign:UIAlignY, yOffset:Int)
	{
		this.xAlign = xAlign;
		this.xOffset = xOffset;

		this.yAlign = yAlign;
		this.yOffset = yOffset;
	}

	public function getElementOffset(e:UIElement):Vector2
	{
		var x = switch (this.xAlign)
		{
			case Left: 0;
			case Right: e.width;
			case Center: Math.round(e.width/2);
		}

		var y = switch (this.yAlign)
		{
			case Top: 0;
			case Bottom: e.height;
			case Center: Math.round(e.height/2);
		}

		return new Vector2(x + this.xOffset, y + this.yOffset);
	}
}
