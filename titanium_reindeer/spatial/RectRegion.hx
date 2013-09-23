package titanium_reindeer.spatial;

class RectRegion extends Rect, implements IRegion
{
	public static function copy(rr:RectRegion):RectRegion
	{
		return new RectRegion(rr.width, rr.height, rr.position.getCopy());
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

	public var position(default, null):Vector2;

	public var top(getTop, never):Float;
	private function getTop():Float { return this.position.y; }

	public var bottom(getBottom, never):Float;
	private function getBottom():Float { return this.position.y + this.height; }

	public var left(getLeft, never):Float;
	private function getLeft():Float { return this.position.x; }

	public var right(getRight, never):Float;
	private function getRight():Float { return this.position.x + this.width; }

	public var center(getCenter, never):Vector2;
	private function getCenter():Vector2
	{
		return this.position.add(new Vector2(this.width/2, this.height/2));
	}

	public function new(width:Float, height:Float, position:Vector2)
	{
		super(width, height);

		if (position == null)
			this.position = new Vector2(0, 0);
		else
			this.position = position.getCopy();
	}

	public function getBoundingRectRegion():RectRegion
	{
		return RectRegion.copy(this);
	}

	public function isPointInside(p:Vector2):Bool
	{
		return (p.x >= this.left) && (p.x < this.right) &&
			   (p.y >= this.top)  && (p.y < this.bottom);
	}
}
