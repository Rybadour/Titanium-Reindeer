package titanium_reindeer.core;

class RectRegion extends Rect, implements IRegion
{
	public static function copy(rr:RectRegion):RectRegion
	{
		return new RectRegion(rr.width, rr.height, rr.center.getCopy());
	}

	public var center(getCenter, setCenter):Vector2;
	public function getCenter():Vector2 { return this.center; }
	public function setCenter(value:Vector2):Vector2
	{
		this.center = value;
		return this.center;
	}

	public var top(getTop, null):Float;
	private function getTop():Float { return this.center.y - this.height/2; }

	public var bottom(getBottom, null):Float;
	private function getBottom():Float { return this.center.y + this.height/2; }

	public var left(getLeft, null):Float;
	private function getLeft():Float { return this.center.x - this.width/2; }

	public var right(getRight, null):Float;
	private function getRight():Float { return this.center.x + this.width/2; }

	public function new(width:Float, height:Float, center:Vector2)
	{
		super(width, height);

		if (center == null)
			this.center = new Vector2(0, 0);
		else
			this.center = center.getCopy();
	}

	public function getBoundingRegion():RectRegion
	{
		return RectRegion.copy(this);
	}

	public override function isPointInside(p:Vector2):Bool
	{
		return super.isPointInside(p.subtract(this.center));
	}
}
