package titanium_reindeer;

import js.Dom;

class ImageRenderer extends RendererComponent
{
	public var image(default, setImage):ImageSource;
	private function setImage(value:ImageSource):ImageSource
	{
		if (value != null && value != this.image)
		{
			this.image = value;

			if (this.image.isLoaded)
				imageLoaded(null);
			else
				this.image.registerLoadEvent(imageLoaded);
		}

		return this.image;
	}
	private var sourceRect:Rect;

	private var destWidth:Float;
	private var destHeight:Float;

	public function new(image:ImageSource, layer:Int, sourceRect:Rect = null, width:Float = 0, height:Float = 0)
	{
		super(0, 0, layer);

		this.sourceRect = sourceRect;
		this.destWidth = width;
		this.destHeight = height;

		this.image = image;
	}

	override public function render():Void
	{
		super.render();

		if (this.image.isLoaded)
		{
			pen.drawImage(this.image.image, sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, -this.destWidth/2, -this.destHeight/2, this.destWidth, this.destHeight);
		}
		else
		{
			this.setRedraw(true);
		}
	}

	private function imageLoaded(event:Event):Void
	{
		if (this.destWidth == 0)
		{
			if (this.sourceRect == null)
				this.destWidth = this.image.width;
			else
				this.destWidth = this.sourceRect.width;
		}
		this.initialDrawnWidth = this.destWidth;


		if (this.destHeight == 0)
		{
			if (this.sourceRect != null)
				this.destHeight = this.sourceRect.height;
			else
				this.destHeight = this.image.height;
		}
		this.initialDrawnHeight = this.destHeight;


		if (this.sourceRect == null)
		{
			this.sourceRect = new Rect(0, 0, this.image.width, this.image.height);
		}

		this.setRedraw(true);
	}

	override public function identify():String
	{
		return super.identify() + "Image("+image.identify()+");";
	}

	override public function destroy():Void
	{
		super.destroy();

		this.image = null;
	}
}
