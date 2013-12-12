package titanium_reindeer.spatial;

class RectRegion extends Rect implements IRegion
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

	public var top(get, never):Float;
	private function get_top():Float { return this.position.y; }

	public var bottom(get, never):Float;
	private function get_bottom():Float { return this.position.y + this.height; }

	public var left(get, never):Float;
	private function get_left():Float { return this.position.x; }

	public var right(get, never):Float;
	private function get_right():Float { return this.position.x + this.width; }

	public var center(get, never):Vector2;
	private function get_center():Vector2
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

	public function expand(margin:Int):Void
	{
		this.position.x -= margin;
		this.position.y -= margin;
		this.width += margin*2;
		this.height += margin*2;
	}

	public function getExpanded(margin:Int):RectRegion
	{
		var region:RectRegion = RectRegion.copy(this);
		region.expand(margin);
		return region;
	}
}