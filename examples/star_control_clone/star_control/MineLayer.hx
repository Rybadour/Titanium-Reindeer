package star_control;

class MineLayer extends Ship
{
	public static inline var MAX_HEALTH 		= 16;
	public static inline var MAX_AMMO			= 10;
	public static inline var RECHARGE_RATE		= 100; 	// ammo /min
	public static inline var FIRE_RATE			= 250; 	// ms wait between shots 
	public static inline var PRIMARY_AMMO_COST	= 4;
	public static inline var TURN_RATE 	 		= Math.PI;		// radians /s
	public static inline var THRUST_ACCEL 		= 200; 			// pixels /s/s
	public static inline var MAX_THRUST 		= 250;			// pixels /s


	public function new(isPlayer1:Bool, shipUi:ShipUi)
	{
		super(isPlayer1, "mineLayer.png", shipUi, MAX_HEALTH, MAX_AMMO, RECHARGE_RATE, FIRE_RATE, PRIMARY_AMMO_COST, TURN_RATE, THRUST_ACCEL, MAX_THRUST);
	}

	public override function shoot(msTimeStep:Int):Void
	{
		var newProjectile:Projectile = new Mine(this);
		this.addProjectile(newProjectile);
	}

	public override function shooting(msTimeStep:Int):Void
	{
		this.attemptShoot(msTimeStep);
	}
}
