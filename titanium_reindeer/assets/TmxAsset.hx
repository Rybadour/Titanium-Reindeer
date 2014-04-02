package titanium_reindeer.assets;

import titanium_reindeer.tiles.tmx.*;
import titanium_reindeer.util.UrlParser;

class TmxAsset extends XmlAsset
{
	public var tmxData:TmxData;
	public var imageLoader:ImageLoader;

	public function (url:String, ?imageLoader:ImageLoader, ?imageBasePath:String)
	{
		super(url);

		this.imageLoader = imageLoader;
		this.imageBasePath = imageBasePath;
	}

	private override function _onLoad(event)
	{
		super._onLoad(event);

		this.tmxData = new TmxData(Xml.parse(this.data));
		if (this.imageLoader != null)
		{
			// Ensure the image path is relative
			if (this.imageBasePath == null)
			{
				var url = new UrlParser(this.url);
				this.imageBasePath = url.getUntilDirectory();
			}

			for (tileSet in this.tmxData.tileSets)
			{
				this.imageLoader.addImage(this.imageBasePath + tileSet.imagePath);
			}
		}
	}
}
