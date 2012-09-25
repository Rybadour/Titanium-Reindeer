package titanium_reindeer;

import titanium_reindeer.core.IShape;

class Rect implements IShape
{
	public static function copy(r:Rect):Rect
	{
		return new Rect(r.width, r.height);
	}

	public var width:Float;
	public var height:Float;

	public function new(width:Float, height:Float)
	{
		this.width = width;
		this.height = height;
	}

	public function getBoundingRect():Rect
	{
		return Rect.copy(this);
	}

	public function isPointInside(p:Vector2):Bool
	{
		var halfWidth:Float = this.width/2;
		var halfHeight:Float = this.height/2;

		return (p.x >= -halfWidth) && (p.x < halfWidth) &&
			   (p.y >= -halfHeight)  && (p.y < halfHeight);
	}

	public function getArea():Float
	{
		return this.width * this.height;
	}
}
