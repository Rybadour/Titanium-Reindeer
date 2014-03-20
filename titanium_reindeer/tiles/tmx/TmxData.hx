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

	/**
	 * Expects a rgb color value as 6 hex characters preceeded by a #.
	 */
	public function setBackgroundColor(str:String):Void
	{
		if (str == null)
		{
			this.backgroundColor = Color.Clear;
		}
		else
		{
			this.backgroundColor = new Color(
				Std.parseInt('0x' + str.substr(1, 2)),
				Std.parseInt('0x' + str.substr(3, 2)),
				Std.parseInt('0x' + str.substr(5, 2))
			);
		}
	}
}
