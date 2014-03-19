package titanium_reindeer.tiles.tmx;

import titanium_reindeer.rendering.Color;

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

	public function setOrientation(str:String):Void
	{
		this.orientation = switch (str)
		{
			case "orthogonal":
			   TileMapOrientation.Orthogonal;	
			case "isometric":
			   TileMapOrientation.Isometric(Normal);
			case "staggered":
			   TileMapOrientation.Isometric(Staggered);
			default:
			   TileMapOrientation.Unknown;
		};
	}
}
