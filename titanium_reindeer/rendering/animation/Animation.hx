package titanium_reindeer.rendering.animation;

class Animation
{
	public var textureAtlas:ITextureAtlas;
	public var frames:Array<Int>;

	public function new(textureAtlas:ITextureAtlas, ?frames:Array<Int>)
	{
		this.textureAtlas = textureAtlas;
		this.frames = frames;
	}

	public function addFrame(atlasIndex:Int):Void
	{
		this.frames.push(atlasIndex);
	}

	public function renderFrame(canvas:Canvas2D, f:Int, destinationWidth:Int, destinationHeight:Int):Void
	{
		if (f >= 0 && frames.length > f)
		{
			this.textureAtlas.renderTexture(canvas, frames[f], destinationWidth, destinationHeight);
		}
	}

	public function getNumFrames()
	{
		return this.frames.length;
	}
}
