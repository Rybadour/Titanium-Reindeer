package star_control;

import titanium_reindeer.Scene;
import titanium_reindeer.ImageSource;
import titanium_reindeer.CollisionCircle;
import titanium_reindeer.CollisionComponent;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;

class BladeTail extends Ship
{
	public static inline var MAX_HEALTH 		= 20;
	public static inline var MAX_AMMO			= 6;
	public static inline var RECHARGE_RATE		= 150; 	// ammo /min
	public static inline var FIRE_RATE			= 500; 	// ms wait between shots 
	public static inline var PRIMARY_AMMO_COST	= 8;
	public static inline var TURN_RATE 	 		= Math.PI;		// radians /s
	public static inline var THRUST_ACCEL 		= 400; 			// pixels /s/s
	public static inline var MAX_THRUST 		= 250;			// pixels /s

	public static inline var SEGMENTS			= 4;
	public static inline var HIT_DAMAGE			= 4;

	public var activeWeapon(default, null):Bool;
	private var lastHit:Int;
	private var lastAmmoDecrement:Int;

	private var segments:Array<BladeTailSegment>;

	public var bladeTailSegmentSource(default, null):ImageSource;
	public var bladeTailSegmentOnSource(default, null):ImageSource;

	public function new(scene:Scene, highlight:Color, shipUi:ShipUi)
	{
		super(scene, highlight, "bladeTailHead.png", shipUi, MAX_HEALTH, MAX_AMMO, RECHARGE_RATE, FIRE_RATE, PRIMARY_AMMO_COST, TURN_RATE, THRUST_ACCEL, MAX_THRUST);

		this.activeWeapon = false;
		this.lastHit = 0;
		this.segments = new Array();

		this.bladeTailSegmentSource = this.scene.getImage("bladeTailSegment.png");
		this.bladeTailSegmentOnSource = this.scene.getImage("bladeTailSegmentOn.png");

		// Build the rest of the tail segments
		var lastSegment:BladeTailSegment = null;
		for (i in 0...SEGMENTS)
		{
			lastSegment = new BladeTailSegment(this, i, lastSegment);
			segments.push(lastSegment);
			this.scene.addGameObject(lastSegment);
		}
	}

	private override function positionHasChanged():Void
	{
		for (segment in this.segments)
		{
			segment.headMoved();
		}
	}

	public override function turn(direction:Direction, msTimeStep:Int):Void
	{
		super.turn(direction, msTimeStep);

		for (segment in this.segments)
		{
			segment.headTurned();
		}
	}

	public function segmentCollided(other:CollisionComponent):Void
	{
		this.collide(other);
	}

	public override function update(msTimeStep:Int):Void
	{
		super.update(msTimeStep);
		
		if (this.lastHit > 0)
		{
			this.lastHit -= msTimeStep; 
		}

		if (this.activeWeapon)
		{
			if (this.lastAmmoDecrement <= 0)
			{
				this.setAmmo( this.ammo - 1 );
				this.lastAmmoDecrement = Math.round(1000/PRIMARY_AMMO_COST);
			}
			else
			{
				this.lastAmmoDecrement -= msTimeStep; 
			}

			if (this.ammo <= 0)
				this.endShooting();
		}
	}

	public override function shooting(msTimeStep:Int):Void
	{
		if (!this.activeWeapon && this.ammo >= 2)
			this.startShooting();
	}

	private override function collide(other:CollisionComponent):Void
	{
		if (this.activeWeapon)
		{
			if (this.lastHit <= 0)
			{
				if ( Std.is(other.owner, Ship) && other.owner != this && !Std.is(other.owner, BladeTailSegment))
				{
					var ship:Ship = cast(other.owner, Ship);
					ship.setHealth( ship.health - BladeTail.HIT_DAMAGE );

					this.lastHit = FIRE_RATE;
				}
			}
		}
		else
		{
			super.collide(other);
		}
	}

	public override function startShooting():Void
	{
		if (this.activeWeapon)
			return;

		this.activeWeapon = true;

		for (segment in this.segments)
		{
			segment.startShooting();
		}
	}

	public override function endShooting():Void
	{
		if (!this.activeWeapon)
			return;

		this.activeWeapon = false;
		
		for (segment in this.segments)
		{
			segment.endShooting();
		}
	}
}
