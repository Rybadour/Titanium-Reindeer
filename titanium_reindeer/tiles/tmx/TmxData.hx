package titanium_reindeer.tiling.tmx;

class TmxData
{
	public var version:String;
	public var orientation:TileMapOrientation;
	public var width:Int;
	public var height:Int;
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var backgroundColor:Color;

	public function new()
	{
	}

	public static function getOrientationFromString(str:String):TileMapOrientation
	{
		return switch (str)
		{
			case "orthogonal":
			   TileMapOrientation.Orthogonal;	
			case "isometric":
			   TileMapOrientation.Isometric(Normal);
			case "staggered":
			   TileMapOrientation.Isometric(Staggered);
			default:
			   TileMapOrientation.Unknown;
	}
}
