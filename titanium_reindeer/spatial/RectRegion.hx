package titanium_reindeer.spatial;

class RectRegion extends Rect implements IRegion
{
	public static function copy(rr:RectRegion):RectRegion
	{
		return new RectRegion(rr.width, rr.height, rr.position.getCopy());
	}

	public static function expandToCover(a:RectRegion, b:RectRegion):RectRegion
	{
		if (a == null)
		{
			if (b == null)
				return null;
			else
				return RectRegion.copy(b);
		}
		else
		{
			if (b == null)
				return RectRegion.copy(a);
		}
		
		// Actual stretch checking
		var left = Math.min(a.left, b.left);
		var top = Math.min(a.top, b.top);
		return new RectRegion(
			Math.max(a.right, b.right) - left,  // Width
			Math.max(a.bottom, b.bottom) - top, // Height
			new Vector2(left, top)
		);
	}

	public var position:Vector2;

	public var top(get, never):Float;
	private inline function get_top():Float { return this.position.y; }

	public var bottom(get, never):Float;
	private inline function get_bottom():Float { return this.position.y + this.height; }

	public var left(get, never):Float;
	private inline function get_left():Float { return this.position.x; }

	public var right(get, never):Float;
	private inline function get_right():Float { return this.position.x + this.width; }

	public var center(get, never):Vector2;
	private inline function get_center():Vector2
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

	public function fullyCoversRectRegion(rect:RectRegion):Bool
	{
		return (this.left <= rect.left &&
				this.right >= rect.right &&
				this.top <= rect.top &&
				this.bottom >= rect.bottom);
	}

	public function intersectsRectRegion(rect:RectRegion):Bool
	{
		return Geometry.isRectIntersectingRect(this, rect);
	}

	public function intersectsCircleRegion(circle:CircleRegion):Bool
	{
		return Geometry.isCircleIntersectingRect(circle, this);
	}

	public function intersectsPoint(p:Vector2):Bool
	{
		return (p.x >= this.left) && (p.x <= this.right) &&
			   (p.y >= this.top)  && (p.y <= this.bottom);
	}
}
