package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.ui.flex.FlexBox;
import titanium_reindeer.ui.flex.*;

class SimpleGrid extends FlexBox
{
	public var numColumns(default, null):Int;
	public var numRows(default, null):Int;
	public var cellWidth(default, null):Int;
	public var cellHeight(default, null):Int;
	public var cellMargin(default, null):Int;
	public var cellRenderer:Int -> Int -> Canvas2D -> Void;

	public function new(numColumns:Int = 1, numRows:Int = 1, cellWidth:Int, cellHeight:Int, cellMargin:Int, cellRenderer:Int -> Int -> Canvas2D -> Void)
	{
		this.numRows = numRows;
		this.numColumns = numColumns;
		this.cellWidth = cellWidth;
		this.cellHeight = cellHeight;
		this.cellMargin = cellMargin;
		this.cellRenderer = cellRenderer;

		super(this.getWidth(), this.getHeight(), this.generateChildren(), FlexDirection.Row, FlexWrap.Wrap);
	}

	public function getWidth():Int
	{
		return this.numColumns * (this.cellWidth + cellMargin);
	}

	public function getHeight():Int
	{
		return this.numRows * (this.cellHeight + cellMargin);
	}

	public function generateChildren():Array<FlexChild>
	{
		var children:Array<FlexChild> = new Array();
		for (r in 0...this.numRows)
		{
			for (c in 0...this.numColumns)
			{
				children.push({
					element: new UIFunction(this.cellWidth, this.cellHeight, function (canvas) {
						this.cellRenderer(r, c, canvas);
					}),
					margin: UIMargin.all(Math.round(this.cellMargin/2)),
				});
			}
		}
		return children;
	}
}
