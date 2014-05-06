import titanium_reindeer.assets.*;
import titanium_reindeer.tiles.tmx.*;

class TmxAssetTests extends haxe.unit.TestCase
{
	public var tmxAsset:TmxAssetMock; 
	public var imageLoader:ImageLoader;

	public var loader:AssetLoader;

	public override function setup()
	{
		this.imageLoader = new ImageLoader();

		var tmxFile:String = File.getContent(tiles.TmxXmlTests.TMX_XML_TEST_FILE);
		this.tmxAsset = new TmxAssetMock(tmxFile, this.imageLoader);

		this.loader = new AssetLoader([
			this.tmxAsset,
			this.imageLoader
		]);
	}

	public function testTileSheetLoading()
	{
		this.loader.load();

		assertEquals(false, this.loader.isLoaded());
	}
}
