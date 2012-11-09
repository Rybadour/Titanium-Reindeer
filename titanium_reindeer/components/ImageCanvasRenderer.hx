package titanium_reindeer.components;

import titanium_reindeer.core.Relation;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.IRegion;
import titanium_reindeer.core.RectRegion;

class ImageCanvasRenderer implements ICanvasRenderer
{
	public var id(default, null):Int;
	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.state; }

	private var relatedBounds:Relation3<Float, Float, Vector2, RectRegion>;
	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion
	{
		return this.relatedBounds.value;
	}

	private var watchedWidth:Watcher<Float>;
	private var watchedHeight:Watcher<Float>;

	public var image(default, setImage):ImageSource;
	private function setImage(value:ImageSource):ImageSource
	{
		if (value != this.image)
		{
			this.image = value;
			if (this.image.isLoaded)
			{
				this.imageLoaded();
			}
		}

		return this.image;
	}

	public function new(provider:IHasIdProvider, image:ImageSource)
	{
		this.id = provider.idProvider.requestId();
		this.state = new CanvasRenderState(this.render);

		var width:Float = 0;
		var height:Float = 0;

		this.image = image;
		if (this.image.isLoaded)
		{
			width = this.image.width;
			height = this.image.height;
		}
		else
			this.image.registerLoadEvent(imageLoaded);

		this.watchedWidth = new Watcher(width);
		this.watchedHeight = new Watcher(height);
		this.relatedBounds = new Relation3(this.watchedWidth, this.watchedHeight, this.state.watchedPosition, getBounds);
	}

	private function imageLoaded():Void
	{
		this.watchedWidth.value = this.image.width;
		this.watchedHeight.value = this.image.height;
	}

	private function getBounds(width:Float, height:Float, position:Vector2):RectRegion
	{
		return new RectRegion(width, height, position);
	}

	private function render(canvas:Canvas2D):Void
	{
		if (this.image.isLoaded)
			canvas.ctx.drawImage(this.image.image, 0, 0, this.image.width, this.image.height, -this.image.width/2, -this.image.height/2, this.image.width, this.image.height);
			//canvas.ctx.drawImage(this.image.image, sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, -this.destWidth/2, -this.destHeight/2, this.destWidth, this.destHeight);
	}
}
