package star_control;

import titanium_reindeer.GameObject;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.RendererComponent;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.Rect;
import titanium_reindeer.Geometry;
import titanium_reindeer.CollisionCircle;
import titanium_reindeer.CollisionComponent;

class Projectile extends GameObject
{
	private static inline var RADIUS 	= 5;

	private var sprite:RendererComponent;
	private var collision:CollisionCircle;
	private var velocity:MovementComponent;

	private var owner:Ship;

	public var speed(default, null):Int;
	public var damage(default, null):Int;
	private var msLifeLeft:Int;

	public function new(owner:Ship, sprite:RendererComponent, speed:Int, damage:Int, msLifeTime:Int)
	{
		super(owner.scene);

		this.owner = owner;

		this.speed = speed;
		this.damage = damage;
		this.msLifeLeft = msLifeTime;

		this.sprite = sprite;
		this.addComponent("sprite", sprite);

		this.collision = new CollisionCircle(RADIUS, "main", CollisionGroups.BULLETS);
		this.collision.registerCallback(collide);
		this.addComponent("collision", this.collision);

		if (this.owner != null)
		{
			var offset:Vector2 = new Vector2(1, 0);
			offset.rotate(this.owner.facing);
			offset.extend(Ship.COLLISION_RADIUS*2);
			this.position = this.owner.position.add(offset);

			offset.normalize();
			offset.extend(this.speed);
			this.velocity = new MovementComponent(offset);
			this.addComponent("velocity", this.velocity);

			this.sprite.rotation = this.owner.facing;
		}
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

		// Only use the life time of the bullet if it's not set to -1 (unlimited)
		if (msLifeLeft != -1)
		{
			msLifeLeft -= msTimeStep;
			if (msLifeLeft <= 0)
			{
				this.owner.removeProjectile(this);
				this.destroy();
			}
		}
	}

	public function collide(other:CollisionComponent):Void
	{
		this.destroy();
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

		this.owner = null;
		this.sprite = null;
		this.collision = null;
		this.velocity = null;
	}
}
