package titanium_reindeer.assets;

import js.html.Image;

class ImageLoader extends AssetLoader
{
	private var rootPath:String;
	private var images:Map<String, ImageAsset>;

	public function new(images:Array<ImageAsset>, ?rootPath:String = '')
	{
		super([]);

		this.rootPath = rootPath;
		this.images = new Map();
		this.addImages(images);
	}

	public function addImages(images:Array<ImageAsset>):Void
	{
		var newImages:Array<ILoadable> = new Array();
		for (image in images)
		{
			if ( ! this.images.exists(image.path))
			{
				// Don't append root (conveinent lookup)
				this.images.set(image.path, image);
				// Append root to the path, must be done before saving...
				image.path = rootPath+image.path;

				newImages.push(image);
			}
		}
	
		// Only load unique image paths
		super.addAssets(newImages);
	}

	public function get(path:String):Image
	{
		return this.images.get(path).image;
	}
}
