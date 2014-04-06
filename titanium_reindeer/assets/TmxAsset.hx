package titanium_reindeer.assets;

import titanium_reindeer.tiles.tmx.*;
import titanium_reindeer.util.UrlParser;

class TmxAsset extends XmlAsset
{
	public var tmxData:TmxData;
	public var imageLoader:ImageLoader;
	public var imageBasePath:String;

	public function new(url:String, ?imageLoader:ImageLoader, ?imageBasePath:String)
	{
		super(url);

		this.imageLoader = imageLoader;
		this.imageBasePath = imageBasePath;
	}

	private override function _onLoad(event)
	{
		super._onLoad(event);

		this.tmxData = new TmxXml(Xml.parse(this.data));
		if (this.imageLoader != null)
		{
			if (this.imageBasePath == null)
				this.imageBasePath = '';

			var images:Array<ImageAsset> = new Array();
			for (tileSet in this.tmxData.tileSets)
				images.push(new ImageAsset(this.imageBasePath + tileSet.imagePath));
			this.imageLoader.addImages(images);
			this.imageLoader.load();
		}
	}
}
