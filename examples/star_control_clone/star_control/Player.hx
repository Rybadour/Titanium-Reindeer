package star_control;

import titanium_reindeer.Enums;
import titanium_reindeer.GameObject;

class Player extends GameObject
{
	private var battleScene:BattleScene;

	public var ship(default, null):Ship;

	public var isThrusting:Bool;
	public var isTurningRight:Bool;
	public var isTurningLeft:Bool;
	public var isShooting:Bool;

	private var thrustKey:Key;
	private var turnRightKey:Key;
	private var turnLeftKey:Key;
	private var shootKey:Key;

	public function new(scene:BattleScene, ship:Ship, thrustKey:Key, turnRightKey:Key, turnLeftKey:Key, shootKey:Key)
	{
		super(scene);

		this.battleScene = scene;

		this.ship = ship;

		this.isThrusting = false;
		this.isTurningRight = false;
		this.isTurningLeft = false;
		this.isShooting = false;

		this.thrustKey = thrustKey;
		this.turnRightKey = turnRightKey;
		this.turnLeftKey = turnLeftKey;
		this.shootKey = shootKey;

		// Input handling
		this.scene.game.inputManager.registerKeyEvent(thrustKey, KeyState.Down, thrustDown);
		this.scene.game.inputManager.registerKeyEvent(thrustKey, KeyState.Up, thrustUp);

		this.scene.game.inputManager.registerKeyEvent(turnRightKey, KeyState.Down, rightDown);
		this.scene.game.inputManager.registerKeyEvent(turnRightKey, KeyState.Up, rightUp);

		this.scene.game.inputManager.registerKeyEvent(turnLeftKey, KeyState.Down, leftDown);
		this.scene.game.inputManager.registerKeyEvent(turnLeftKey, KeyState.Up, leftUp);

		this.scene.game.inputManager.registerKeyEvent(shootKey, KeyState.Down, shootDown);
		this.scene.game.inputManager.registerKeyEvent(shootKey, KeyState.Up, shootUp);
	}

	private function thrustDown():Void
	{
		this.isThrusting = true;
	}

	private function thrustUp():Void
	{
		this.isThrusting = false;
	}

	private function rightDown():Void
	{
		this.isTurningRight = true;
	}

	private function rightUp():Void
	{
		this.isTurningRight = false;
	}

	private function leftDown():Void
	{
		this.isTurningLeft = true;
	}

	private function leftUp():Void
	{
		this.isTurningLeft = false;
	}

	private function shootDown():Void
	{
		this.isShooting = true;
		this.ship.startShooting();
	}

	private function shootUp():Void
	{
		this.isShooting = false;
		this.ship.endShooting();
	}

	public override function update(msTimeStep:Int):Void
	{
		if (this.ship.health <= 0)
		{
			this.battleScene.notifyShipDied(this);
		}

		if (this.isThrusting)
		{
			this.ship.thrust(msTimeStep);
		}

		if (this.isTurningRight && !this.isTurningLeft)
		{
			this.ship.turn(Direction.Right, msTimeStep);
		}

		if (this.isTurningLeft && !this.isTurningRight)
		{
			this.ship.turn(Direction.Left, msTimeStep);
		}

		if (this.isShooting)
		{
			this.ship.shooting(msTimeStep);
		}
	}
}
