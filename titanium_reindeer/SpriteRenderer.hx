package titanium_reindeer;

import js.Dom;

class Animation
{
	public var name:String;
	public var frameRate:Int;
	public var frames:Array<Int>;

	private var currentFrame(default, null):Int;
	private var msTimeToFrameSwitch:Int;

	public function new(name:String, frames:Array<Int>, frameRate:Int)
	{
		this.name = name;
		this.frames = frames;
		this.frameRate = frameRate;
	}

	public function getFrame():Int
	{
		if (this.currentFrame == -1)
			return -1;

		else
			return this.frames[this.currentFrame];
	}

	public function update(msTimeStep:Int):Void
	{
		this.msTimeToFrameSwitch -= msTimeStep;

		if (this.msTimeToFrameSwitch < 0)
		{
			this.msTimeToFrameSwitch += Std.int(1000/this.frameRate);
			this.currentFrame++;

			if (this.frames.length <= this.currentFrame)
				this.currentFrame = -1;
		}
	}

	public function reset():Void
	{
		this.currentFrame = 0;
	}
}

class SpriteRenderer extends ImageRenderer
{
	private var animations:Hash<Animation>;
	public var currentAnimation:String;
	private var isLooping:Bool;
	private var lastFrame:Int;

	private var frameWidth:Float;
	private var frameHeight:Float;

	private var sheetWidth:Int;
	private var sheetHeight:Int;

	public function new(image:ImageSource, layer:Int, frameWidth:Float, frameHeight:Float, width:Float = 0, height:Float = 0)
	{
		var sourceRect:Rect = new Rect(0, 0, frameWidth, frameHeight);
		if (width == 0)
			width = frameWidth;
		if (height == 0)
			height = frameHeight;

		super(image, layer, sourceRect, width, height);

		this.isLooping = false;
		this.lastFrame = -1;

		this.frameWidth = frameWidth;
		this.frameHeight = frameHeight;

		this.animations = new Hash();
		this.currentAnimation = null;
	}

	private override function imageLoaded(event:Event):Void
	{
		super.imageLoaded(event);

		this.sheetWidth = this.image.width;
		this.sheetHeight = this.image.height;
	}

	public override function update(msTimeStep:Int):Void
	{
		super.update(msTimeStep);

		if (!this.image.isLoaded)
			return;

		if (this.currentAnimation != null)
		{
			this.animations.get(this.currentAnimation).update(msTimeStep);

			var currentFrame:Int = this.animations.get(this.currentAnimation).getFrame();
			if (currentFrame == -1)
			{
				if (this.isLooping)
					this.animations.get(this.currentAnimation).reset();
				else
					this.stop();
			}
			else if (this.lastFrame != currentFrame)
			{
				this.lastFrame = currentFrame;
				var x:Int = Std.int(currentFrame*frameWidth);
				this.sourceRect.x = x % this.sheetWidth;
				this.sourceRect.y = Math.floor(x / this.sheetWidth);
				this.setRedraw(true);
			}
		}
	}

	public function play(animation:String, isLooping:Bool):Void
	{
		if ( this.animations.exists(animation) )
		{
			this.currentAnimation = animation;
			this.isLooping = isLooping;
		}
	}

	public function stop():Void
	{
		this.currentAnimation = null;
		this.isLooping = false;
	}

	public function addAnimation(name:String, frames:Array<Int>, frameRate:Int)
	{
		if (name == null || frames == null || frames.length <= 0)
			return;

		this.animations.set(name, new Animation(name, frames, frameRate) );
	}
}
