package titanium_reindeer.tiles.tmx;

/**
 * The class responsible for taking an XML document and mapping it to the TmxData typed definition
 * of a given TmxMap.
 */
class TmxXml extends TmxData
{
	public function new(xml:Xml)
	{
		super();

		var map:Xml = null;
		for (element in xml.elements())
		{
			if (element.nodeName == "map")
			{
				map = element;
				break;
			}
		}

		if (map == null)
		{
			throw "TmxXml given an Xml document without a map node!";
			return;
		}

		this.version         = map.get('version');
		this.width           = Std.parseInt(map.get('width'));
		this.height          = Std.parseInt(map.get('height'));
		this.tileWidth       = Std.parseInt(map.get('tileWidth'));
		this.tileHeight      = Std.parseInt(map.get('tileHeight'));
		this.backgroundColor = map.get('backgroundcolor');
		this.setOrientation( TmxData.getOrientationFromString(map.get('orientation')) );
	}
}
