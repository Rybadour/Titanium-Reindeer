package titanium_reindeer.components;

import js.Dom;

class Canvas2D
{
	public var canvas(default, null):Dynamic;
	public var ctx(default, null):Dynamic;

	public var width(default, setWidth):Float;
	private var setWidth(value:Float):Float
	{
		if (this.width != value)
		{
			this.width = value;
			this.canvas.setAttribute("width", this.width+"px");
		}

		return this.width;
	}

	public var height(default, setHeight):Float;
	private var setWidth(value:Float):Float
	{
		if (this.width != value)
		{
			this.width = value;
			this.canvas.setAttribute("height", this.height+"px");
		}

		return this.width;
	}

	public function new(name:String, width:Float, height:Float)
	{
		this.canvas = js.Lib.document.createElement("canvas"); 
		this.canvas.id = name;

		this.width = width;
		this.height = height;

		this.ctx = this.canvas.getContext("2d");
	}

	public function appendToDom(element:HtmlDom)
	{
		element.appendChild(this.canvas);
	}

	public function clear(rect:Rect = null):Void
	{
		if (rect == null)
			rect = new Rect(0, 0, this.width, this.height);

		this.ctx.clearRect(rect.x, rect.y, rect.width, rect.height);
	}
}
