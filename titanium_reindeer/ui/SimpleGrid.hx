package titanium_reindeer.ui;

class SimpleGrid extends FlexBox
{
	public var numColumns(default, null):Int;
  public var numRows(default, null):Int;
  public var cellWidth(default, null):Int;
  public var cellHeight(default, null):Int;
  public var cellMargin(default, null):Int;

	public function new(position:Vector2, numColumns:Int = 1, numRows:Int = 1, cellWidth:Int, cellHeight:Int, cellMargin:Int)
	{
		this.numRows = numRows;
		this.numColumns = numColumns;
		this.cellWidth = cellWidth;
		this.cellHeight = cellHeight;
		this.cellMargin = cellMargin;

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
