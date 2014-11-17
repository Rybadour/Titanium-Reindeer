package titanium_reindeer.rendering.animation;

class Sprite extends Renderer<RenderState>
{
	public var animations:Map<String, Animation>;
	public var width:Int;
	public var height:Int;

	public var currentAnimationName:String;
	public var currentAnimation:Animation;
	public var currentFrame:Int;
	public var playing:Bool;
	public var looping:Bool;
	public var elapsedMs:Int;
	public var durationMs:Int;

	public function new(animations:Map<String, Animation>, width:Int, height:Int)
	{
		this.animations = animations;
		this.width = width;
		this.height = height;
		this.playing = false;

		super(new RenderState());
	}

	public function playAnimation(name:String, durationMs:Int, ?looping:Bool = false):Void
	{
		if (this.animations.exists(name))
		{
			this.looping = looping;
			this.durationMs = durationMs;
			this.elapsedMs = 0;
	
			this.playing = true;
			this.currentAnimationName = name;
			this.currentAnimation = this.animations.get(name);
			this.currentFrame = 0;
		}
	}

	public function stopAnimation(?keepLastFrame:Bool = true)
	{
		this.playing = false;
		if (keepLastFrame)
		{
			// Keep the last frame of the animation so it can still be rendered
			this.currentFrame = this.currentAnimation.getNumFrames() - 1;
		}
	}

	public function update(msTimeStep:Int):Void
	{
		if (this.playing)
		{
			if (this.elapsedMs > this.getFrameTime(this.currentFrame + 1))
			{
				this.currentFrame = this.getFrameFromTime(this.elapsedMs);
				if (this.currentAnimation.getNumFrames() <= this.currentFrame)
				{
					if (this.looping)
					{
						this.elapsedMs -= this.durationMs;
						this.currentFrame = 0;
					}
					else
					{
						this.stopAnimation(true);
						// Intended to skip the elapsed += timeStep line
						return;
					}
				}
			}
			this.elapsedMs += msTimeStep;
		}
	}

	public function clearAnimation():Void
	{
		this.stopAnimation(false);
		this.currentAnimation = null;
		this.currentAnimationName = '';
	}

	public function getFrameTime(frame:Int):Int
	{
		return Math.round(this.durationMs * (frame / this.currentAnimation.getNumFrames()));
	}

	public function getFrameFromTime(timeMs:Int):Int
	{
		return Math.floor(this.currentAnimation.getNumFrames() * (timeMs / this.durationMs));
	}

	private override function _render(canvas:Canvas2D):Void
	{
		if (this.currentAnimation != null)
		{
			this.currentAnimation.renderFrame(canvas, this.currentFrame, this.width, this.height);
		}
	}
}
