import titanium_reindeer.Scene;
import titanium_reindeer.InputManager;
import titanium_reindeer.Game;
import titanium_reindeer.GameObject;
import titanium_reindeer.Color;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.RendererComponent;
import titanium_reindeer.InputManager;
import titanium_reindeer.Shadow;
import titanium_reindeer.Enums;

class CirclePlayer extends MovableObject
{
	public var testScene:TestScene;

	public var friend:CirclePlayer;

	private var radius:Int;
	private var jumpSpeed:Float;

	private var color:Color;

	private var enabled:Bool;

	private var leftKey:Key;
	private var rightKey:Key;
	private var upKey:Key;

	public function new(scene:TestScene, leftKey:Key, rightKey:Key, upKey:Key, color:Color)
	{		
		super(scene, new Vector2(0, 0));

		this.testScene = scene;

		this.radius = 20;
		this.jumpSpeed = 50;

		this.color = color;

		var circ:RectRenderer = new RectRenderer(this.radius*2, this.radius*2, Layers.MID);
		circ.alpha = 0.6;
		circ.fillColor = color;
		circ.lineWidth = 2;
		circ.strokeColor = new Color(0, 0, 0);
		circ.shadow = new Shadow(new Color(0, 0, 0, 0.4), new Vector2(3, 3), 6);
		this.addComponent("mainCircle", circ);

		this.leftKey = leftKey;
		this.rightKey = rightKey;
		this.upKey = upKey;

		this.scene.game.inputManager.registerKeyEvent(Key.Shift, KeyState.Up, toggle);
		this.enabled = false;
		this.toggle();
	}

	override public function update(msTimeStep:Int):Void
	{
		if (this.position.y + this.radius < testScene.groundY)
		{
			this.velocity.y += 1;
		}
		else
		{
			this.position.y = testScene.groundY - this.radius;
		}
	}

	private function left():Void
	{
		this.position.x -= 2;
	}
	private function right():Void
	{
		this.position.x += 2;
	}

	private function up():Void
	{
		if (this.position.y + this.radius >= testScene.groundY)
			this.velocity.y = -this.jumpSpeed;
		else
		{
			var diff:Vector2 = this.position.subtract(friend.position);
			if (diff.getMagnitude() < this.radius)
				this.velocity.y = -this.jumpSpeed;
		}
	}

	private function toggle():Void
	{
		if (this.enabled)
		{
			this.scene.game.inputManager.unregisterKeyEvent(rightKey, KeyState.Held, right);
			this.scene.game.inputManager.unregisterKeyEvent(leftKey, KeyState.Held, left);
			this.scene.game.inputManager.unregisterKeyEvent(upKey, KeyState.Down, up);
		}
		else
		{
			this.scene.game.inputManager.registerKeyEvent(rightKey, KeyState.Held, right);
			this.scene.game.inputManager.registerKeyEvent(leftKey, KeyState.Held, left);
			this.scene.game.inputManager.registerKeyEvent(upKey, KeyState.Down, up);
		}

		this.enabled = !this.enabled;
	}

	override public function destroy():Void
	{
		super.destroy();

		testScene = null;
		friend = null;
	
		color = null;
	}
}
