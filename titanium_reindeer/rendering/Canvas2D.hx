package titanium_reindeer.rendering;

import js.html.Element;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Image;

import titanium_reindeer.spatial.RectRegion;
import titanium_reindeer.spatial.Rect;
import titanium_reindeer.spatial.Circle;

class Canvas2D implements IRenderer
{
	public var offset(default, null):Vector2;
	public var canvas(default, null):CanvasElement;
	public var ctx(default, null):CanvasRenderingContext2D;

	public var width(default, set):Int;
	private function set_width(value:Int):Int
	{
		if (this.width != value)
		{
			this.width = value;
			this.canvas.setAttribute("width", this.width+"px");
		}

		return this.width;
	}

	public var height(default, set):Int;
	private function set_height(value:Int):Int
	{
		if (this.height != value)
		{
			this.height = value;
			this.canvas.setAttribute("height", this.height+"px");
		}

		return this.height;
	}

	public function new(name:String, width:Int, height:Int)
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

	public function save()
	{
		this.ctx.save();
	}

	public function restore()
	{
		this.ctx.restore();
	}

	public function translatef(x:Float, y:Float)
	{
		this.ctx.translate(x, y);
	}

	public inline function translate(vector:Vector2)
	{
		this.ctx.translate(vector.x, vector.y);
	}

	public inline function moveTo(vector:Vector2)
	{
		this.ctx.moveTo(vector.x, vector.y);
	}

	public inline function lineTo(vector:Vector2)
	{
		this.ctx.lineTo(vector.x, vector.y);
	}

	public inline function renderImage(image:Image)
	{
		this.ctx.drawImage(image, 0, 0);
	}

	public inline function renderCanvas(canvas:Canvas2D)
	{
		untyped { this.ctx.drawImage(canvas.canvas, 0, 0); }
	}

	public inline function renderRectf(width:Float, height:Float)
	{
		this.ctx.fillRect(0, 0, width, height);
		this.ctx.strokeRect(0, 0, width, height);
	}
	
	public inline function renderRect(rect:Rect)
	{
		this.renderRectf(rect.width, rect.height);
	}

	public function renderCircle(circle:Circle)
	{
		this.ctx.beginPath();
		this.ctx.arc(0, 0, circle.radius, 0, 2*Math.PI, false);
		this.ctx.fill();
		this.ctx.stroke();
		this.ctx.closePath();
	}

	public function renderText(text:String)
	{
		this.ctx.fillText(text, 0, 0);
		this.ctx.strokeText(text, 0, 0);
	}

	public function clear(rect:RectRegion = null):Void
	{
		if (rect == null)
			rect = new RectRegion(this.width, this.height, new Vector2(this.width/2, this.height/2));

		this.ctx.clearRect(rect.left, rect.top, rect.width, rect.height);
	}

	public function render(canvas:Canvas2D)
	{
		canvas.renderCanvas(this);
	}
}
