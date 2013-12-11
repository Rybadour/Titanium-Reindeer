package titanium_reindeer.rendering;

class Color
{
	// Pre-defined colors
	// Creates a new color object each time incase the object is modified later
	public static var Red(get, never):Color;
	public static function get_Red():Color { return new Color(255, 0, 0); }
	public static var Orange(get, never):Color;
	public static function get_Orange():Color { return new Color(255, 127, 0); }
	public static var Yellow(get, never):Color;
	public static function get_Yellow():Color { return new Color(255, 205, 0); }
	public static var Green(get, never):Color;
	public static function get_Green():Color { return new Color(0, 255, 0); }
	public static var Blue(get, never):Color;
	public static function get_Blue():Color { return new Color(0, 0, 255); }
	public static var Purple(get, never):Color;
	public static function get_Purple():Color { return new Color(128, 0, 128); }

	public static var White(get, never):Color;
	public static function get_White():Color { return new Color(255, 255, 255); }
	public static var Black(get, never):Color;
	public static function get_Black():Color { return new Color(0, 0, 0); }
	public static var Grey(get, never):Color;
	public static function get_Grey():Color { return new Color(128, 128, 128); }

	public static var Clear(get, never):Color;
	public static function get_Clear():Color { return new Color(0, 0, 0, 0); }


	public var red:Int;
	public var green:Int;
	public var blue:Int;
	public var alpha:Float;

	public var rgba(get, never):String;
	public function get_rgba():String
	{
		return "rgba("+red+","+green+","+blue+","+alpha+")";
	}

	public function new(red:Int, green:Int, blue:Int, alpha:Float = 1)
	{
		this.red = cast( Math.max(0, Math.min(red, 255)), Int );
		this.green = cast( Math.max(0, Math.min(green, 255)), Int );
		this.blue = cast( Math.max(0, Math.min(blue, 255)), Int );
		this.alpha = Math.max(0, Math.min(alpha, 1));
	}

	public function equal(other:Color):Bool
	{
		return this.red == other.red &&
			   this.green == other.green &&
			   this.blue == other.blue &&
			   this.alpha == other.alpha;
	}

	public function getCopy():Color
	{
		return new Color(this.red, this.green, this.blue, this.alpha);
	}

	public function identify():String
	{
		return "Color("+red+","+green+","+blue+","+alpha+");";
	}

	public function getMultiplied(n:Float):Color
	{
		return new Color(Std.int(this.red*n), Std.int(this.green*n), Std.int(this.blue*n));
	}

	public function multiply(n:Float):Void
	{
		this.red = Std.int(this.red*n);
		this.green = Std.int(this.green*n);
		this.blue = Std.int(this.blue*n);
	}
}
