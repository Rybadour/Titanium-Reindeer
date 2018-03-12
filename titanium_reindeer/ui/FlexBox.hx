package titanium_reindeer.ui;

class FlexBox extends UIElement
{
	public function new(position:Vector2, children:Array<>)
	{
		super(position, this.getWidth(), this.getHeight()
	}

	public function getWidth():Int
	{
		return (this.numColumns * this.cellWidth) + (cellMargin * (this.numColumns-1));
	}

	public function getHeight():Int
	{
		return (this.numRows * this.cellHeight) + (cellMargin * (this.numRows-1));
	}
}
