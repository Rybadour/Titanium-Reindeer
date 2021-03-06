package titanium_reindeer.rendering;

import js.html.Element;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Image;

import titanium_reindeer.spatial.Vector2;
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

		this.ctx = this.canvas.getContext2d({alpha: false});
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
		this.ctx.translate(Math.round(x), Math.round(y));
	}

	public inline function translate(vector:Vector2)
	{
		this.translatef(vector.x, vector.y);
	}

	public inline function scale(sx:Float, ?sy:Float = null):Void
	{
		this.ctx.scale(sx, ( sy == null ? sx : sy ));
	}

	public inline function rotate(r:Float):Void
	{
		this.ctx.rotate(r);
	}

	public inline function moveTof(x:Float, y:Float)
	{
		this.ctx.moveTo(Math.round(x), Math.round(y));
	}

	public inline function moveTo(vector:Vector2)
	{
		this.moveTof(vector.x, vector.y);
	}

	public inline function lineTof(x:Float, y:Float)
	{
		this.ctx.lineTo(Math.round(x), Math.round(y));
	}

	public inline function lineTo(vector:Vector2)
	{
		this.lineTof(vector.x, vector.y);
	}

	public inline function renderLinef(ax:Float, ay:Float, bx:Float, by:Float)
	{
		this.ctx.beginPath();
		this.moveTof(ax, ay);
		this.lineTof(bx, by);
		this.ctx.stroke();
		this.ctx.closePath();
	}

	public inline function renderLine(a:Vector2, b:Vector2)
	{
		this.renderLinef(a.x, a.y, b.x, b.y);
	}

	public inline function renderImage(image:Image)
	{
		this.ctx.drawImage(image, 0, 0);
	}

	public inline function renderImageCentered(image:Image, x:Int, y:Int, width:Int, height:Int, rotation:Float)
	{
		this.save();
		this.translatef(width/2, height/2);
		this.ctx.rotate(rotation);
		this.ctx.drawImage(image, Math.round(x - width/2), Math.round(y - height/2), width, height);
		this.restore();
	}

	public inline function renderCanvas(canvas:Canvas2D)
	{
		untyped { this.ctx.drawImage(canvas.canvas, 0, 0); }
	}

	public inline function renderRectf(width:Float, height:Float)
	{
		width = Math.round(width);
		height = Math.round(height);
		this.ctx.fillRect(0, 0, width, height);
		this.ctx.strokeRect(0, 0, width, height);
	}
	
	public inline function renderRect(rect:Rect)
	{
		this.renderRectf(rect.width, rect.height);
	}

	public inline function renderRectRegion(rect:RectRegion)
	{
		this.translate(rect.position);
		this.renderRect(rect);
	}

	public function renderCirclef(radius:Float)
	{
		this.ctx.beginPath();
		this.ctx.arc(0, 0, radius, 0, 2*Math.PI, false);
		this.ctx.fill();
		this.ctx.stroke();
		this.ctx.closePath();
	}

	public function renderCircle(circle:Circle)
	{
		this.renderCirclef(circle.radius);
	}

	public function renderText(text:String)
	{
		this.ctx.fillText(text, 0, 0);
		this.ctx.strokeText(text, 0, 0);
	}

	/**
	 * Set the current fill style to the specified color.
	 */
	public function fillColor(color:Color):Void
	{
		this.ctx.fillStyle = color.rgba;
	}

	/**
	 * Set the current stroke style to the specified color.
	 */
	public function strokeColor(color:Color):Void
	{
		this.ctx.strokeStyle = color.rgba;
	}

	public function clear(rect:RectRegion = null):Void
	{
		if (rect == null)
			this.ctx.clearRect(0, 0, Math.round(this.width), Math.round(this.height));
		else
			this.ctx.clearRect(Math.round(rect.left), Math.round(rect.top), Math.round(rect.width), Math.round(rect.height));
	}

	public function render(canvas:Canvas2D)
	{
		canvas.renderCanvas(this);
	}

	public function resize(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;
	}
}
