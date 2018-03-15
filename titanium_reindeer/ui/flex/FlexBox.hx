package titanium_reindeer.ui.flex;

import titanium_reindeer.rendering.Canvas2D;

typedef FlexChild = {
	var element:UIElement;
	var margin:UIMargin;
}

class FlexBox extends UIElement
{
	public var children:Array<FlexChild>;
	public var direction:FlexDirection;
	public var wrap:FlexWrap;

	public function new(width:Int, height:Int, children:Array<FlexChild>, direction:FlexDirection, wrap:FlexWrap)
	{
		super(width, height);

		this.children = children;
		this.direction = direction;
		this.wrap = wrap;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		canvas.save();
		switch (this.direction)
		{
			case Row:           this._renderRow(canvas);
			case RowReverse:    this._renderRowReverse(canvas);
			case Column:        this._renderColumn(canvas);
			case ColumnReverse: this._renderColumnReverse(canvas);
		}
		canvas.restore();
	}

	private function getChildWidth(child:FlexChild):Int
	{
		return child.margin.left + child.element.width + child.margin.right;
	}

	private function getChildHeight(child:FlexChild):Int
	{
		return child.margin.top + child.element.height + child.margin.bottom;
	}

	private function _renderRow(canvas:Canvas2D):Void
	{
		var biggestHeight = 0;
		var x = 0;
		var y = 0;
		for (child in this.children)
		{
			if (this.wrap == Wrap)
			{
				x += this.getChildWidth(child);
				if (x > this.width)
				{
					x = this.getChildWidth(child);
					y += biggestHeight;
					biggestHeight = 0;
					canvas.restore();
					canvas.save();
					canvas.translatef(0, y);
				}
				var height = this.getChildHeight(child);
				if (biggestHeight < height)
					biggestHeight = height;
			}

			canvas.translatef(child.margin.left, child.margin.top);
			child.element.render(canvas);
			canvas.translatef(
				(child.element.width + child.margin.right),
				-child.margin.top
			);
		}
	}

	private function _renderRowReverse(canvas:Canvas2D):Void
	{
		var biggestHeight = 0;
		var x = this.width;
		var y = 0;
		canvas.translatef(x, y);
		for (child in this.children)
		{
			if (this.wrap == Wrap)
			{
				x -= this.getChildWidth(child);
				if (x < 0)
				{
					y += biggestHeight;
					biggestHeight = 0;
					x = this.width - this.getChildWidth(child);
					canvas.restore();
					canvas.save();
					canvas.translatef(0, y);
				}
				var height = this.getChildHeight(child);
				if (biggestHeight < height)
					biggestHeight = height;
			}

			canvas.translatef(
				-(child.margin.right + child.element.width),
				child.margin.top
			);
			child.element.render(canvas);
			canvas.translatef(-child.margin.left, -child.margin.top);
		}
	}

	private function _renderColumn(canvas:Canvas2D):Void
	{
		var biggestWidth = 0;
		var x = 0;
		var y = 0;
		for (child in this.children)
		{
			if (this.wrap == Wrap)
			{
				y += this.getChildHeight(child);
				if (y > this.height)
				{
					x += biggestWidth;
					y = this.getChildHeight(child);
					biggestWidth = 0;
					canvas.restore();
					canvas.save();
					canvas.translatef(x, 0);
				}
				var width = this.getChildWidth(child);
				if (biggestWidth < width)
					biggestWidth = width;
			}

			canvas.translatef(child.margin.right, child.margin.top);
			child.element.render(canvas);
			canvas.translatef(-child.margin.right, child.element.height + child.margin.bottom);
		}
	}

	private function _renderColumnReverse(canvas:Canvas2D):Void
	{
		var biggestWidth = 0;
		var x = 0;
		var y = this.height;
		canvas.translatef(x, y);
		for (child in this.children)
		{
			if (this.wrap == Wrap)
			{
				y -= this.getChildHeight(child);
				if (y < 0)
				{
					x += biggestWidth;
					y = this.height - this.getChildHeight(child);
					biggestWidth = 0;
					canvas.restore();
					canvas.save();
					canvas.translatef(x, 0);
				}
				var width = this.getChildWidth(child);
				if (biggestWidth < width)
					biggestWidth = width;
			}

			canvas.translatef(
				child.margin.right,
				-(child.margin.top + child.element.height)
			);
			child.element.render(canvas);
			canvas.translatef(-child.margin.right, -child.margin.bottom);
		}
	}

}
