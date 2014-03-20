package unit_testing.tiles;

import titanium_reindeer.tiles.tmx.*;
import titanium_reindeer.tiles.*;
import titanium_reindeer.rendering.Color;

class TmxXmlTests extends haxe.unit.TestCase
{
	public var tmxMap:TmxMap;
	public var tmxXmlData:TmxXml;
	public var xml_data:String;

	public override function setup()
	{
		this.xml_data =
		'<?xml version="1.0" encoding="UTF-8"?>' +
		'<map version="1.0" orientation="orthogonal" width="30" height="30" tilewidth="16" tileheight="16">' +
			'<tileset firstgid="1" name="Dungeon" tilewidth="16" tileheight="16">' +
				'<image source="dungeon_tiles_compact_and_varied.png" width="336" height="104"/>' +
				'<terraintypes>' +
					'<terrain name="dirt" tile="-1"/>' +
					'<terrain name="water" tile="-1"/>' +
				'</terraintypes>' +
				'<tile id="0" terrain="1,1,1,0"/>' +
				'<tile id="1" terrain="1,1,0,0"/>' +
				'<tile id="2" terrain="1,1,0,0"/>' +
				'<tile id="3" terrain="1,1,0,0"/>' +
				'<tile id="4" terrain="1,1,0,1"/>' +
			'</tileset>' +
		'</map>';
	}

	public function testParseXml()
	{
		this.tmxXmlData = new TmxXml(Xml.parse(this.xml_data));

		assertEquals(this.tmxXmlData.version, "1.0");
		assertEquals(this.tmxXmlData.orientation, TileMapOrientation.Orthogonal);
		assertEquals(this.tmxXmlData.width, 30);
		assertEquals(this.tmxXmlData.height, 30);
		assertEquals(this.tmxXmlData.tileWidth, 16);
		assertEquals(this.tmxXmlData.tileHeight, 16);
		assertTrue( Color.Clear.equal(this.tmxXmlData.backgroundColor) );
	}
}
