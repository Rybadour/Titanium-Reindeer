package titanium_reindeer;

class Color
{
	// Pre-defined colors
	// Creates a new color object each time incase the object is modified later
	public static var Red(getRedConst, never):Color;
	public static function getRedConst():Color { return new Color(255, 0, 0); }
	public static var Orange(getOrangeConst, never):Color;
	public static function getOrangeConst():Color { return new Color(255, 127, 0); }
	public static var Yellow(getYellowConst, never):Color;
	public static function getYellowConst():Color { return new Color(255, 205, 0); }
	public static var Green(getGreenConst, never):Color;
	public static function getGreenConst():Color { return new Color(0, 255, 0); }
	public static var Blue(getBlueConst, never):Color;
	public static function getBlueConst():Color { return new Color(0, 0, 255); }
	public static var Purple(getPurpleConst, never):Color;
	public static function getPurpleConst():Color { return new Color(128, 0, 128); }

	public static var White(getWhiteConst, never):Color;
	public static function getWhiteConst():Color { return new Color(255, 255, 255); }
	public static var Black(getBlackConst, never):Color;
	public static function getBlackConst():Color { return new Color(0, 0, 0); }
	public static var Grey(getGreyConst, never):Color;
	public static function getGreyConst():Color { return new Color(128, 128, 128); }

	public static var Clear(getClearConst, never):Color;
	public static function getClearConst():Color { return new Color(0, 0, 0, 0); }


	public var red:Int;
	public var green:Int;
	public var blue:Int;
	public var alpha:Float;

	public var rgba(getRgba, never):String;
	public function getRgba():String
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
}
