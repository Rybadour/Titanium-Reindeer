package titanium_reindeer.core;

class RectRegion extends Rect, implements IRegion
{
	public static function copy(rr:RectRegion):RectRegion
	{
		return new RectRegion(rr.width, rr.height, rr.center.getCopy());
	}

	public static function expandToCover(coverage:RectRegion, toFit:RectRegion):RectRegion
	{
		if (coverage == null)
		{
			if (toFit == null)
				return null;
			else
				return RectRegion.copy(toFit);
		}
		else
		{
			if (toFit == null)
				return RectRegion.copy(coverage);
		}

		// Actual stretch checking
		var left:Float = Math.min(coverage.left, toFit.left);
		var top:Float = Math.min(coverage.top, toFit.top);
		var width:Float = Math.max(coverage.right, toFit.right) - left;
		var height:Float = Math.max(coverage.bottom, toFit.bottom) - top;

		return new RectRegion(
			width, height,
			new Vector2(left + width/2, top + height/2)
		);
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

	public function getBoundingRectRegion():RectRegion
	{
		return RectRegion.copy(this);
	}

	public override function isPointInside(p:Vector2):Bool
	{
		return super.isPointInside(p.subtract(this.center));
	}
}
