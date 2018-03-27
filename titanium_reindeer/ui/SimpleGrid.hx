package titanium_reindeer.ui;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.spatial.Vector2;
import titanium_reindeer.ui.flex.FlexBox;
import titanium_reindeer.ui.flex.*;

class SimpleGrid extends UIElement
{
	public var numColumns(default, null):Int;
	public var numRows(default, null):Int;
	public var cellWidth(default, null):Int;
	public var cellHeight(default, null):Int;
	public var cellMargin(default, null):Int;
	public var cellRenderer:Int -> Int -> Canvas2D -> Void;
	public var cells:Array<FlexChild>;

	public function new(numColumns:Int = 1, numRows:Int = 1, cellWidth:Int, cellHeight:Int, cellMargin:Int, cellRenderer:Int -> Int -> Canvas2D -> Void)
	{
		this.numRows = numRows;
		this.numColumns = numColumns;
		this.cellWidth = cellWidth;
		this.cellHeight = cellHeight;
		this.cellMargin = cellMargin;
		this.cellRenderer = cellRenderer;
		this.cells = this.generateCells();

		super(this.getWidth(), this.getHeight());

		FlexBox.positionElements(this.width, this.height, this.cells, FlexDirection.Row, FlexWrap.Wrap);
	}

	private override function _render(canvas:Canvas2D):Void
	{
		for (cell in this.cells)
		{
			cell.element.render(canvas);
		}
	}

	public function getCellIndexOfMouse(mousePos:Vector2):Int
	{
		var c = Math.floor(mousePos.x / (this.cellWidth + this.cellMargin));
		var r = Math.floor(mousePos.y / (this.cellHeight + this.cellMargin));
		var offsetC = mousePos.x % (this.cellWidth + this.cellMargin);
		var offsetR = mousePos.y % (this.cellHeight + this.cellMargin);
		if (c >= 0 && c < this.numColumns && r >= 0 && r < this.numRows)
		{
			var sideMargin = this.cellMargin/2;
			if (offsetC >= sideMargin && offsetC <= this.cellWidth + sideMargin &&
				offsetR >= sideMargin && offsetR <= this.cellHeight + sideMargin)
			{
				return c + (r * this.numColumns);
			}
		}

		return null;
	}

	public function getWidth():Int
	{
		return this.numColumns * (this.cellWidth + this.cellMargin);
	}

	public function getHeight():Int
	{
		return this.numRows * (this.cellHeight + this.cellMargin);
	}

	public function generateCells():Array<FlexChild>
	{
		var cells:Array<FlexChild> = new Array();
		for (r in 0...this.numRows)
		{
			for (c in 0...this.numColumns)
			{
				cells.push({
					element: new UIFunction(this.cellWidth, this.cellHeight, function (canvas) {
						this.cellRenderer(r, c, canvas);
					}),
					margin: UIMargin.all(Math.round(this.cellMargin/2)),
				});
			}
		}
		return cells;
	}
}
