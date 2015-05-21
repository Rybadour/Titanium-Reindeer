package titanium_reindeer.spatial;

class Vector2
{
	public static function getDistance(a:Vector2, b:Vector2):Float
	{
		return Math.sqrt( (b.x-a.x)*(b.x-a.x) + (b.y-a.y)*(b.y-a.y) );
	}

	public static function getReflected(surfaceNormal:Vector2, incoming:Vector2)
	{
		var outgoing:Vector2 = new Vector2(1, 0);
		var surfaceRadians:Float = surfaceNormal.getRadians();
		var incomingRadians:Float = incoming.getReverse().getRadians();

		var rad:Float = (surfaceRadians*2 - incomingRadians) % (Math.PI*2); 
		outgoing.rotate(rad);

		return outgoing;
	}

	public static function fromAngle(rad:Float):Vector2
	{
		var v:Vector2 = new Vector2(1, 0);
		v.rotate(rad);
		return v;
	}

	public static function normalizedDiff(a:Vector2, b:Vector2):Vector2
	{
		var diff:Vector2 = b.subtract(a);
		diff.normalize();
		return diff;
	}

	public static function getDotProduct(a:Vector2, b:Vector2):Float
	{
		return (a.x*b.x + a.y*b.y);
	}


	public var x:Float;
	public var y:Float;

	public function new(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}
	
	public function getCopy()
	{
		return new Vector2(this.x, this.y);
	}
	
	public inline function getMagnitude()
	{
		return Math.sqrt(this.getMagnitudeSquared());
	}

	public inline function getMagnitudeSquared()
	{
		return this.x*this.x + this.y*this.y;
	}

	public inline function setMagnitude(newMag:Float):Void
	{
		var angle = this.getRadians();
		this.x = newMag;
		this.y = 0;
		this.rotate(angle);
	}
	
	public function getExtend(n:Float)
	{
		return new Vector2(this.x * n, this.y * n);
	}
	public function extend(n:Float)
	{
		this.x *= n;
		this.y *= n;
	}

	public function getNormalized()
	{
		var mag = this.getMagnitude();
		if (mag == 0)
			return new Vector2(0, 0);
		return new Vector2(this.x/mag, this.y/mag);
	}
	public function normalize()
	{
		var mag = this.getMagnitude();
		if (mag != 0)
		{
			this.x /= mag;
			this.y /= mag;
		}
	}
	
	public function getReverse()
	{
		return new Vector2(-this.x, -this.y);
	}
	public function reverse()
	{
		this.x = -this.x;
		this.y = -this.y;
	}
	
	public function getRotate(r:Float)
	{
		var sin = Math.sin(r);
		var cos = Math.cos(r);
		return new Vector2(this.x * cos - this.y * sin,
		                   this.x * sin + this.y * cos);
	}
	public function rotate(r:Float)
	{
		var sin = Math.sin(r);
		var cos = Math.cos(r);
		var x:Float = this.x;
		this.x = this.x * cos - this.y * sin;
		this.y = x * sin + this.y * cos;
	}

	// Returns the angle of this vector in radians
	public function getRadians()
	{
		if (this.x == 0)
			return Math.PI/2 + (this.y < 0 ? Math.PI : 0);

		var rads:Float = Math.atan(this.y / this.x);

		if (this.x < 0)
			rads += Math.PI;
		else if (this.y < 0)
			rads += Math.PI*2;

		return rads;
	}
	
	public function add(b:Vector2)
	{
		if (b == null)
			return this.getCopy();

		return new Vector2(this.x + b.x, this.y + b.y);
	}
	public function addTo(b:Vector2)
	{
		this.x += b.x;
		this.y += b.y;

		return this;
	}
	
	public function subtract(b:Vector2)
	{
		return new Vector2(this.x - b.x, this.y - b.y);
	}
	public function subtractFrom(b:Vector2)
	{
		this.x -= b.x;
		this.y -= b.y;

		return this;
	}

	public function equal(other:Vector2)
	{
		return this.x == other.x && this.y == other.y;
	}

	public function identify():String
	{
		return "Vector2("+x+","+y+")";
	}
}
