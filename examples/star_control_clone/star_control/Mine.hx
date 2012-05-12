package star_control;

import titanium_reindeer.ImageRenderer;

class Mine extends Projectile
{
	public static inline var SPEED 		= 200; 	// pixels /s
	public static inline var DAMAGE 	= 8;
	public static inline var LIFE_TIME 	= -1; 	// ms

	public static inline var DRAG		= 100; 	// pixels /s/s

	public function new(owner:Ship)
	{
		var sprite:ImageRenderer = new ImageRenderer(owner.scene.getImage("mine.png"), BattleScene.SHIPS_LAYER);

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

