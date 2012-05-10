package star_control;

import titanium_reindeer.GameObject;
import titanium_reindeer.Scene;
import titanium_reindeer.Vector2;
import titanium_reindeer.ImageRenderer;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.Enums;
import titanium_reindeer.Rect;
import titanium_reindeer.CollisionCircle;
import titanium_reindeer.CollisionComponent;
import titanium_reindeer.Color;
import titanium_reindeer.Shadow;
import titanium_reindeer.SoundSource;

class Ship extends GameObject
{
	public static inline var COLLISION_RADIUS 	= 20;
	public static inline var DRAG				= 25;			// pixels /s/s

	public static inline var HIT_SOUND 			= "sound/ship_hit.mp3";
	public static inline var HIT_SOUND2			= "sound/ship_hit.mp3";


	private var sprite:ImageRenderer;
	private var playerHighlight:CircleRenderer;
	private var collision:CollisionCircle;
	private var velocity:MovementComponent;
	
	private var hitSound:SoundSource;
	private var hitSound2:SoundSource;

	private var shipUi:ShipUi;

	public var maxHealth(default, null):Int;
	public var maxAmmo(default, null):Int;
	public var rechargeRate(default, null):Int;		// ammo /min
	public var fireRate(default, null):Int;			// ms wait between shots
	public var primaryAmmoCost(default, null):Int;
	public var turnRate(default, null):Float;			// radians /s
	public var thrustAccel(default, null):Int;		// pixels /s/s
	public var maxThrust(default, null):Int;		// pixels /s/s

	public var health(default, null):Int;
	public var ammo(default, null):Int;
	public var ammoRemainder:Float;

	private var msNextShot:Int; 				// ms until next shot
	public var facing(default, null):Float;
	private var projectiles:IntHash<Projectile>;

	public function new(scene:Scene, highlight:Color, imagePath:String, shipUi:ShipUi, maxHealth:Int, maxAmmo:Int, rechargeRate:Int, fireRate:Int, primaryAmmoCost:Int, turnRate:Float, thrustAccel:Int, maxThrust:Int)
	{
		super(scene);

		this.sprite = new ImageRenderer(this.scene.getImage(imagePath), BattleScene.SHIPS_LAYER);
		this.sprite.shadow = new Shadow(highlight, new Vector2(4, 4), 20);
		this.addComponent("sprite", this.sprite);

		this.playerHighlight = new CircleRenderer(COLLISION_RADIUS + 10, BattleScene.BELOW_SHIPS_LAYER);
		this.playerHighlight.fillColor = new Color(0, 0, 0, 1);
		this.playerHighlight.shadow = new Shadow(highlight, new Vector2(0, 0), 0.5);
		//this.addComponent("playerHighlight", this.playerHighlight);
		
		this.collision = new CollisionCircle(COLLISION_RADIUS, "main", CollisionGroups.SHIPS);
		this.collision.registerCallback(collide);
		this.addComponent("collision", this.collision);

		this.velocity = new MovementComponent();
		this.addComponent("velocity", this.velocity);

		this.hitSound = this.scene.game.soundManager.getSound(Ship.HIT_SOUND);
		this.hitSound2 = this.scene.game.soundManager.getSound(Ship.HIT_SOUND2);

		this.shipUi = shipUi;

		this.maxHealth = maxHealth;
		this.maxAmmo = maxAmmo;
		this.rechargeRate = rechargeRate;
		this.fireRate = fireRate;
		this.primaryAmmoCost = primaryAmmoCost;
		this.turnRate = turnRate;
		this.thrustAccel = thrustAccel;
		this.maxThrust = maxThrust;

		if (this.shipUi != null)
		{
			this.shipUi.initialize(this.maxHealth, this.maxAmmo);
		}

		this.health = this.maxHealth;
		this.ammo = this.maxAmmo;

		this.ammoRemainder = 0;

		this.msNextShot = 0;
		this.projectiles = new IntHash();
	}

	public function reset(startPos:Vector2):Void
	{
		this.position = startPos;

		this.setHealth(this.maxHealth);

		this.velocity.velocity = new Vector2(0, 0);

		// Reset all the ships projectiles
		var tempProjectiles:Array<Projectile> = new Array();
		for (projectile in this.projectiles)
			tempProjectiles.push(projectile);
		for (projectile in tempProjectiles)
		{
			projectile.destroy();
			this.scene.removeGameObject(projectile);
			this.projectiles.remove(projectile.id);
		}
	}

	public function thrust(msTimeStep:Int):Void
	{
		var thrust:Vector2 = new Vector2(1, 0);
		thrust.rotate(this.facing);
		thrust.extend(this.thrustAccel * (msTimeStep/1000));
		this.velocity.velocity.addTo(thrust);

		if (this.velocity.velocity.getMagnitude() > this.maxThrust)
		{
			var velo:Vector2 = this.velocity.velocity;
			velo.normalize();
			velo.extend(this.maxThrust);
		}
	}

	public function turn(direction:Direction, msTimeStep:Int):Void
	{
		this.facing += (direction == Direction.Right ? this.turnRate : -this.turnRate) * (msTimeStep/1000);
		this.sprite.rotation = this.facing;
	}

	public function enoughAmmo():Bool
	{
		return (this.ammo - this.primaryAmmoCost) > 0;
	}

	private function attemptShoot(msTimeStep:Int):Void
	{
		if (this.msNextShot <= 0 && this.enoughAmmo())
		{
			this.shoot(msTimeStep);

			this.setAmmo(this.ammo - this.primaryAmmoCost);

			this.msNextShot = this.fireRate;
		}
	}

	public function shoot(msTimeStep:Int):Void
	{
	}

	public function startShooting():Void
	{
	}

	public function shooting(msTimeStep:Int):Void
	{
	}

	public function endShooting():Void
	{
	}

	public override function update(msTimeStep:Int):Void
	{
		var fieldRect:Rect = StarControlGame.getFieldRect();

		if (this.position.x < fieldRect.left)
			this.position.x += fieldRect.width - 10;

		else if (this.position.x > fieldRect.right)
			this.position.x -= fieldRect.width - 10;

		else if (this.position.y < fieldRect.top)
			this.position.y += fieldRect.height - 10;

		else if (this.position.y > fieldRect.bottom)
			this.position.y -= fieldRect.height - 10;

		if (this.msNextShot > 0)
		{
			this.msNextShot -= msTimeStep;
		}

		if (this.ammo < this.maxAmmo)
		{
			this.ammoRemainder += this.rechargeRate * (msTimeStep/60000); 	// rate /min
			
			if (this.ammoRemainder >= 1)
			{
				this.setAmmo(this.ammo + Math.floor(this.ammoRemainder));
				this.ammoRemainder -= Math.floor(this.ammoRemainder);
			}
		}

		var speed:Float = this.velocity.velocity.getMagnitude();
		if (speed > 0)
		{
			speed = Math.max(0, speed - DRAG * (msTimeStep/1000));
			this.velocity.velocity.normalize();
			this.velocity.velocity.extend(speed);
		}
	}

	private function collide(other:CollisionComponent):Void
	{
		if (Std.is(other.owner, Projectile))
		{
			var projectile:Projectile = cast(other.owner, Projectile);
			this.setHealth(this.health - projectile.damage);

			this.scene.game.soundManager.playRandomSound([this.hitSound, this.hitSound2]);
		}
	}

	public function setHealth(value:Int):Void
	{
		value = Math.floor( Math.max(0, Math.min(value, this.maxHealth)) );

		this.health = value;
		this.shipUi.updateHealth(this.health);
	}

	private function setAmmo(value:Int):Void
	{
		value = Math.floor( Math.max(0, Math.min(value, this.maxAmmo)) );

		this.ammo = value;
		this.shipUi.updateAmmo(this.ammo);
	}

	private function addProjectile(projectile:Projectile):Void
	{
		this.scene.addGameObject(projectile);
		this.projectiles.set(projectile.id, projectile);
	}

	public function removeProjectile(projectile:Projectile):Void
	{
		if (projectiles.exists(projectile.id))
		{
			this.scene.removeGameObject(projectile);
			this.projectiles.remove(projectile.id);
		}
	}

	public override function destroy():Void
	{
		super.destroy();

		this.removeComponent("sprite");
		this.removeComponent("collision");
		this.removeComponent("velocity");

		this.sprite.destroy();
		this.collision.destroy();
		this.velocity.destroy();
	}

	public override function finalDestroy():Void
	{
		super.finalDestroy();

		this.sprite = null;
		this.collision = null;
		this.velocity = null;
	}
}
