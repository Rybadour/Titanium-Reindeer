package unit_testing.tiles;

import haxe.io.Eof;
import sys.io.File;
import neko.Lib;

import titanium_reindeer.tiles.tmx.*;
import titanium_reindeer.tiles.*;
import titanium_reindeer.rendering.Color;

class TmxXmlTests extends haxe.unit.TestCase
{
	public static inline var TMX_CSV_TEST_FILE:String = 'tiles/csv_test.tmx';
	public static inline var TMX_XML_TEST_FILE:String = 'tiles/xml_test.tmx';

	public var tmxMap:TmxMap;
	public var tmxXmlWithCsv:TmxXml;
	public var tmxXmlWithXml:TmxXml;
	public var tmxCsvData:String;
	public var tmxXmlData:String;

	public override function setup()
	{
		this.tmxCsvData = File.getContent(TMX_CSV_TEST_FILE);
		this.tmxXmlData = File.getContent(TMX_XML_TEST_FILE);
	}

	public function testParseXmlWithCsvData()
	{
		this.tmxXmlWithCsv = new TmxXml(Xml.parse(this.tmxCsvData));

		assertEquals(this.tmxXml.version, "1.0");
		assertEquals(this.tmxXml.orientation, TileMapOrientation.Orthogonal);
		assertEquals(this.tmxXml.width, 30);
		assertEquals(this.tmxXml.height, 30);
		assertEquals(this.tmxXml.tileWidth, 16);
		assertEquals(this.tmxXml.tileHeight, 16);
		assertTrue( Color.Black.equal(this.tmxXml.backgroundColor) );
	}

	public function testParseXmlWithXmlData()
	{
		this.tmxXmlWithXml = new TmxXml(Xml.parse(this.tmxXmlData));

		assertEquals(this.tmxXml.version, "1.0");
		assertEquals(this.tmxXml.orientation, TileMapOrientation.Orthogonal);
		assertEquals(this.tmxXml.width, 30);
		assertEquals(this.tmxXml.height, 30);
		assertEquals(this.tmxXml.tileWidth, 16);
		assertEquals(this.tmxXml.tileHeight, 16);
		assertTrue( Color.Black.equal(this.tmxXml.backgroundColor) );
	}
}
