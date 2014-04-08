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

		assertEquals(this.tmxXmlWithCsv.version, "1.0");
		assertEquals(this.tmxXmlWithCsv.orientation, TileMapOrientation.Orthogonal);
		assertEquals(this.tmxXmlWithCsv.width, 30);
		assertEquals(this.tmxXmlWithCsv.height, 30);
		assertEquals(this.tmxXmlWithCsv.tileWidth, 16);
		assertEquals(this.tmxXmlWithCsv.tileHeight, 16);
		assertTrue( Color.Black.equal(this.tmxXmlWithCsv.backgroundColor) );
	}

	public function testParseXmlWithXmlData()
	{
		this.tmxXmlWithXml = new TmxXml(Xml.parse(this.tmxXmlData));

		assertEquals(this.tmxXmlWithXml.version, "1.0");
		assertEquals(this.tmxXmlWithXml.orientation, TileMapOrientation.Orthogonal);
		assertEquals(this.tmxXmlWithXml.width, 30);
		assertEquals(this.tmxXmlWithXml.height, 30);
		assertEquals(this.tmxXmlWithXml.tileWidth, 16);
		assertEquals(this.tmxXmlWithXml.tileHeight, 16);
		assertTrue( Color.Black.equal(this.tmxXmlWithXml.backgroundColor) );
	}
}
