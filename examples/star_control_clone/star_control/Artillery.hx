package star_control;

import titanium_reindeer.Scene;
import titanium_reindeer.SoundSource;

class Artillery extends Ship
{
	public static inline var MAX_HEALTH 		= 14;
	public static inline var MAX_AMMO			= 16;
	public static inline var RECHARGE_RATE		= 300; 			// ammo /min
	public static inline var FIRE_RATE			= 500; 			// ms wait between shots 
	public static inline var PRIMARY_AMMO_COST	= 8;
	public static inline var TURN_RATE 	 		= Math.PI/2;	// radians /s
	public static inline var THRUST_ACCEL 		= 100; 			// pixels /s/s
	public static inline var MAX_THRUST 		= 150; 			// pixels /s/s

	public static inline var FIRE_SOUND			= "sound/artillery_fire.mp3";


	private var fireSound:SoundSource;

	public function new(scene:Scene, isPlayer1:Bool, shipUi:ShipUi)
	{
		super(scene, isPlayer1, "artillery.png", shipUi, MAX_HEALTH, MAX_AMMO, RECHARGE_RATE, FIRE_RATE, PRIMARY_AMMO_COST, TURN_RATE, THRUST_ACCEL, MAX_THRUST);

		this.fireSound = this.scene.game.soundManager.getSound(Artillery.FIRE_SOUND);
	}

	public override function shoot(msTimeStep:Int):Void
	{
		var newProjectile:Projectile = new ArtilleryShell(this);
		this.addProjectile(newProjectile);

		this.scene.game.soundManager.playSound(this.fireSound);
	}

	public override function shooting(msTimeStep:Int):Void
	{
		this.attemptShoot(msTimeStep);
	}
}
