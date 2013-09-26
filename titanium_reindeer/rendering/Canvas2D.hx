package titanium_reindeer.rendering;

import js.html.Element;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

import titanium_reindeer.spatial.RectRegion;
import titanium_reindeer.spatial.Rect;
import titanium_reindeer.spatial.Circle;

class Canvas2D
{
	public var canvas(default, null):CanvasElement;
	public var ctx(default, null):CanvasRenderingContext2D;

	public var width(default, set):Float;
	private function set_width(value:Float):Float
	{
		if (this.width != value)
		{
			this.width = value;
			this.canvas.setAttribute("width", this.width+"px");
		}

		return this.width;
	}

	public var height(default, set):Float;
	private function set_height(value:Float):Float
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
		this.canvas = js.Browser.document.createCanvasElement(); 
		this.canvas.id = name;

		this.width = width;
		this.height = height;

		this.ctx = this.canvas.getContext2d();
	}

	public function appendToDom(element:Element)
	{
		element.appendChild(this.canvas);
	}

	public function translate(vector:Vector2)
	{
		this.ctx.translate(vector.x, vector.y);
	}

	public function moveTo(vector:Vector2)
	{
		this.ctx.moveTo(vector.x, vector.y);
	}

	public function lineTo(vector:Vector2)
	{
		this.ctx.lineTo(vector.x, vector.y);
	}
	
	public function renderRect(rect:Rect)
	{
		this.ctx.fillRect(
			0, 0,
			rect.width, rect.height
		);
		this.ctx.strokeRect(
			0, 0,
			rect.width, rect.height
		);
	}

	public function renderCircle(circle:Circle)
	{
		this.ctx.beginPath();
		this.ctx.arc(0, 0, circle.radius, 0, 2*Math.PI, false);
		this.ctx.fill();
		this.ctx.stroke();
		this.ctx.closePath();
	}

	public function clear(rect:RectRegion = null):Void
	{
		if (rect == null)
			rect = new RectRegion(this.width, this.height, new Vector2(this.width/2, this.height/2));

		this.ctx.clearRect(rect.left, rect.top, rect.width, rect.height);
	}
}
