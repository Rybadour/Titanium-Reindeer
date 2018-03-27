package titanium_reindeer.ui.flex;

import titanium_reindeer.rendering.Canvas2D;

typedef FlexChild = {
	var element:UIElement;
	var margin:UIMargin;
}

class FlexBox
{
	public static function positionElements(width:Int, height:Int, children:Array<FlexChild>, direction:FlexDirection, wrap:FlexWrap)
	{
		switch (direction)
		{
			case Row:           _row(width, height, children, wrap);
			case RowReverse:    _rowReverse(width, height, children, wrap);
			case Column:        _column(width, height, children, wrap);
			case ColumnReverse: _columnReverse(width, height, children, wrap);
		}
	}

	private static function _getChildWidth(child:FlexChild):Int
	{
		return child.margin.left + child.element.width + child.margin.right;
	}

	private static function _getChildHeight(child:FlexChild):Int
	{
		return child.margin.top + child.element.height + child.margin.bottom;
	}

	private static function _row(width:Int, height:Int, children:Array<FlexChild>, wrap:FlexWrap):Void
	{
		var biggestHeight = 0;
		var x = 0;
		var y = 0;
		for (child in children)
		{
			x += FlexBox._getChildWidth(child);
			if (wrap == Wrap)
			{
				if (x > width)
				{
					x = FlexBox._getChildWidth(child);
					y += biggestHeight;
					biggestHeight = 0;
				}
				var height = FlexBox._getChildHeight(child);
				if (biggestHeight < height)
					biggestHeight = height;
			}

			child.element.position.x = x - child.margin.right - child.element.width;
			child.element.position.y = y + child.margin.top;
		}
	}

	private static function _rowReverse(width:Int, height:Int, children:Array<FlexChild>, wrap:FlexWrap):Void
	{
		var biggestHeight = 0;
		var x = width;
		var y = 0;
		for (child in children)
		{
			x -= FlexBox._getChildWidth(child);
			if (wrap == Wrap)
			{
				if (x < 0)
				{
					y += biggestHeight;
					biggestHeight = 0;
					x = width - FlexBox._getChildWidth(child);
				}
				var height = FlexBox._getChildHeight(child);
				if (biggestHeight < height)
					biggestHeight = height;
			}

			child.element.position.x = x + child.margin.left;
			child.element.position.y = y + child.margin.top;
		}
	}

	private static function _column(width:Int, height:Int, children:Array<FlexChild>, wrap:FlexWrap):Void
	{
		var biggestWidth = 0;
		var x = 0;
		var y = 0;
		for (child in children)
		{
			y += FlexBox._getChildHeight(child);
			if (wrap == Wrap)
			{
				if (y > height)
				{
					x += biggestWidth;
					y = FlexBox._getChildHeight(child);
					biggestWidth = 0;
				}
				var width = FlexBox._getChildWidth(child);
				if (biggestWidth < width)
					biggestWidth = width;
			}

			child.element.position.x = x + child.margin.left;
			child.element.position.y = y - child.margin.bottom - child.element.height;
		}
	}

	private static function _columnReverse(width:Int, height:Int, children:Array<FlexChild>, wrap:FlexWrap):Void
	{
		var biggestWidth = 0;
		var x = 0;
		var y = height;
		for (child in children)
		{
			y -= FlexBox._getChildHeight(child);
			if (wrap == Wrap)
			{
				if (y < 0)
				{
					x += biggestWidth;
					y = height - FlexBox._getChildHeight(child);
					biggestWidth = 0;
				}
				var width = FlexBox._getChildWidth(child);
				if (biggestWidth < width)
					biggestWidth = width;
			}

			child.element.position.x = x + child.margin.left;
			child.element.position.y = y + child.margin.top;
		}
	}

}
