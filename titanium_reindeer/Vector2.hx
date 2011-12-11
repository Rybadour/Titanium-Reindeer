package titanium_reindeer;

class Vector2
{
	public static function getDistance(a:Vector2, b:Vector2):Float
	{
		return Math.sqrt( (b.x-a.x)*(b.x-a.x) + (b.y-a.y)*(b.y-a.y) );
	}

	private var mX:Float;
	public var x(getX, setX):Float;
	private function getX():Float { return mX; }
	private function setX(value:Float):Float
	{
		mX = value;
		return mX;
	}

	private var mY:Float;
	public var y(getY, setY):Float;
	private function getY():Float { return mY; }
	private function setY(value:Float):Float
	{
		mY = value;
		return mY;
	}

	public function new(x:Float, y:Float)
	{
		this.mX = x;
		this.mY = y;
	}

	public static function getReflected(surfaceNormal, incoming)
	{
		var outgoing:Vector2 = new Vector2(1, 0);
		var surfaceRadians:Float = surfaceNormal.getRadians();
		var incomingRadians:Float = incoming.getReverse().getRadians();

		var rad:Float = (surfaceRadians*2 - incomingRadians) % (Math.PI*2); 
		outgoing.rotate(rad);

		return outgoing;
	}
	
	public function getCopy()
	{
		return new Vector2(this.x, this.y);
	}
	
	public function getMagnitude()
	{
		return Math.sqrt(this.x*this.x + this.y*this.y);
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
	
	public function equal(b:Vector2)
	{
		if (b == null)
			return false;

		return this.x == b.x && this.y == b.y;
	}

	public function identify():String
	{
		return "Vector2("+x+","+y+")";
	}
}
