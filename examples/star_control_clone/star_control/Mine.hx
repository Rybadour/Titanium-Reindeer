package star_control;

import titanium_reindeer.ImageRenderer;
import titanium_reindeer.ImageSource;

class Mine extends Projectile
{
	public static inline var SPEED 		= 200; 	// pixels /s
	public static inline var DAMAGE 	= 8;
	public static inline var LIFE_TIME 	= -1; 	// ms

	public static inline var DRAG		= 100; 	// pixels /s/s
	//public static var mineImage:ImageSource = new ImageSource(StarControlGame.IMAGE_BASE + "mine.png");

	public function new(owner:Ship)
	{
		var sprite:ImageRenderer = new ImageRenderer(new ImageSource(StarControlGame.IMAGE_BASE + "mine.png"), Layers.SHIPS);

		super(owner, sprite, SPEED, DAMAGE, LIFE_TIME);
	}

	public override function update(msTimeStep:Int):Void
	{
		super.update(msTimeStep);

		var speed:Float = this.velocity.velocity.getMagnitude();
		if (speed > 0)
		{
			speed = Math.max(0, speed - DRAG * (msTimeStep/1000));
			this.velocity.velocity.normalize();
			this.velocity.velocity.extend(speed);
		}
	}
}

