package titanium_reindeer.rendering;

import js.Dom;

import titanium_reindeer.spatial.RectRegion;
import titanium_reindeer.spatial.Rect;
import titanium_reindeer.spatial.Circle;

class Canvas2D
{
	public var canvas(default, null):Dynamic;
	public var ctx(default, null):Dynamic;

	public var width(default, setWidth):Float;
	private function setWidth(value:Float):Float
	{
		if (this.width != value)
		{
			this.width = value;
			this.canvas.setAttribute("width", this.width+"px");
		}

		return this.width;
	}

	public var height(default, setHeight):Float;
	private function setHeight(value:Float):Float
	{
		if (this.height != value)
		{
			this.height = value;
			this.canvas.setAttribute("height", this.height+"px");
		}

		return this.height;
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

	public function translate(vector:Vector2)
	{
		this.ctx.translate(vector.x, vector.y);
	}
	
	public function renderRect(rect:Rect)
	{
		this.ctx.fillRect(
			0, 0,
			rect.width, rect.height
		);
	}

	public function renderCircle(circle:Circle)
	{
		this.ctx.beginPath();
		this.ctx.arc(0, 0, circle.radius, 0, 2*Math.PI, false);
		this.ctx.fill();
		this.ctx.closePath();
	}

	public function clear(rect:RectRegion = null):Void
	{
		if (rect == null)
			rect = new RectRegion(this.width, this.height, new Vector2(this.width/2, this.height/2));

		this.ctx.clearRect(rect.left, rect.top, rect.width, rect.height);
	}
}
