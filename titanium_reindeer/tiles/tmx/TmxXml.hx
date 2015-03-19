package titanium_reindeer.tiles.tmx;

/**
 * The class responsible for taking an XML document and mapping it to the TmxData typed definition
 * of a given TmxMap.
 */
class TmxXml extends TmxData
{
	public function new(xml:Xml)
	{
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
		this.sourceTileWidth  = this.tileWidth  = Std.parseInt(map.get('tilewidth'));
		this.sourceTileHeight = this.tileHeight = Std.parseInt(map.get('tileheight'));
		this.setBackgroundColor( map.get('backgroundcolor') );
		this.setOrientation( map.get('orientation') );
		this.customProperties = parseProperties(map);

		this.tileSets = new Array();
		for (tileSet in map.elementsNamed("tileset"))
		{
			var tileSetData = new TmxTileSet();
			tileSetData.firstTileId    = Std.parseInt(tileSet.get('firstgid'));
			// TODO: Support external Tilesets through source attribute
			tileSetData.name             = tileSet.get('name');
			tileSetData.tileWidth        = Std.parseInt(tileSet.get('tilewidth'));
			tileSetData.tileHeight       = Std.parseInt(tileSet.get('tileheight'));
			tileSetData.spacing          = Std.parseInt(tileSet.get('spacing'));
			tileSetData.margin           = Std.parseInt(tileSet.get('margin'));
			tileSetData.customProperties = parseProperties(tileSet);

			// TODO: Handle tile offset

			// Note: there should be only one
			var images = tileSet.elementsNamed('image');
			for (image in images)
			{
				tileSetData.imagePath   = image.get('source');
				tileSetData.imageWidth  = Std.parseInt(image.get('width'));
				tileSetData.imageHeight = Std.parseInt(image.get('height'));
				break;
			}
			// TODO: Support embedded image data
			
			tileSetData.terrains = new Array();
			for (terrainTypes in tileSet.elementsNamed('terraintypes'))
			{
				for (terrain in terrainTypes.elementsNamed('terrain'))
				{
					var terrainData = new TmxTerrain(terrain.get('name'), Std.parseInt(terrain.get('tile')));
					terrainData.customProperties = parseProperties(terrain);
					tileSetData.terrains.push(terrainData);
				}
			}

			tileSetData.tiles = new Array();
			for (tile in tileSet.elementsNamed('tile'))
			{
				var tileData = new TmxTile(Std.parseInt(tile.get('id')));
				var terrain = tile.get('terrain');
				if (terrain != null)
				{
					var corners = terrain.split(',');
					tileData.terrainTopLeft     = Std.parseInt(corners[0]);
					tileData.terrainTopRight    = Std.parseInt(corners[1]);
					tileData.terrainBottomLeft  = Std.parseInt(corners[2]);
					tileData.terrainBottomRight = Std.parseInt(corners[3]);
					tileData.terrainProbability = Std.parseFloat(tile.get('probability'));
				}
				tileData.customProperties   = parseProperties(tile);
				tileSetData.tiles.push(tileData);
			}

			this.tileSets.push(tileSetData);
		}

		// Parse Layers
		this.layers = new Array();
		for (layer in map.elementsNamed("layer"))
		{
			var layerData = new TmxLayer(this);
			layerData.name    = layer.get('name');
			layerData.layerX  = Std.parseInt(layer.get('x'));
			layerData.layerY  = Std.parseInt(layer.get('y'));
			layerData.width   = Std.parseInt(layer.get('width'));
			layerData.height  = Std.parseInt(layer.get('height'));
			layerData.opacity = Std.parseFloat(layer.get('opacity'));
			layerData.visible = layer.get('visible') != '0';

			layerData.tileIndices = new Array();
			for (data in layer.elementsNamed("data"))
			{
				// Defaults to xml
				if (!data.exists('encoding'))
				{
					for (tile in data.elementsNamed("tile"))
					{
						layerData.tileIndices.push(Std.parseInt(tile.get('gid')));
					}
				}
				else
				{
					var raw:String = data.toString();
					if (data.get('encoding') == 'csv')
					{
						for (gid in raw.split(','))
						{
							layerData.tileIndices.push(Std.parseInt(gid));
						}
					}
					else if (data.get('encoding') == 'base64')
					{
						// TODO
					}
				}
			}

			this.layers.push(layerData);
		}

		super();
	}

	/**
	 * Return list of properties directly under under a node.
	 */
	public function parseProperties(node:Xml):Map<String, String>
	{
		var tmxProperties:Map<String, String> = new Map();
		for (properties in node.elementsNamed("properties"))
		{
			for (property in properties.elementsNamed("property"))
			{
				tmxProperties.set(property.get('name'), property.get('value'));
			}
		}
		return tmxProperties;
	}
}
