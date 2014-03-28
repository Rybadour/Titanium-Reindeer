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

		this.version    = map.get('version');
		this.width      = Std.parseInt(map.get('width'));
		this.height     = Std.parseInt(map.get('height'));
		this.tileWidth  = Std.parseInt(map.get('tilewidth'));
		this.tileHeight = Std.parseInt(map.get('tileheight'));
		this.setBackgroundColor( map.get('backgroundcolor') );
		this.setOrientation( map.get('orientation') );
		this.customProperties = parseProperties(map);

		for (tileSet in map.elementsNamed("tileset"))
		{
			var tileSetData = new TmxTileSet();
			tileSetData.firstGlobalId = tileSet.get('firstgid');
			// TODO: Support external Tilesets through source attribute
			tileSetData.name = tileSet.get('name');
			tileSetData.tileWidth = tileSet.get('tileWidth');
			tileSetData.tileHeight = tileSet.get('tileHeight');
			tileSetData.spacing = tileSet.get('spacing');
			tileSetData.margin = tileSet.get('margin');
			tileSetData.customProperties = parseProperties(tileSet);
		}
	}

	// Return list of properties directly under this node
	public function parseProperties(node:Xml)
	{
		for (
	}
}
