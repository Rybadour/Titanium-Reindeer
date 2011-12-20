import titanium_reindeer.Game;
import titanium_reindeer.GameObject;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.RectangleRenderer;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;
import titanium_reindeer.CollisionRectangle;
import titanium_reindeer.RendererComponent;
import titanium_reindeer.InputManager;
import titanium_reindeer.ImageRenderer;
import titanium_reindeer.ImageSource;
import titanium_reindeer.Rect;
import titanium_reindeer.Circle;
import titanium_reindeer.UnsaturateEffect;
import titanium_reindeer.PixelatedEffect;
import titanium_reindeer.TextRenderer;
import titanium_reindeer.StrokeFillRenderer;
import titanium_reindeer.Pattern;
import titanium_reindeer.ColorStop;
import titanium_reindeer.LinearGradient;
import titanium_reindeer.Shadow;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.Enums;

class TestGame extends Game
{
	public static function main():Void
	{
		var game:TestGame = new TestGame();
		game.play();
	}


	public var groundY(default, null):Float;

	public var groundHeight(getGroundHeight, null):Float;
	private function getGroundHeight():Float
	{
		return this.height - groundY;
	}

	private var lastDrag:Vector2;

	private var circle:CirclePlayer;
	private var circle2:CirclePlayer;
	private var imageMan:GameObject;
	private var imageBox:GameObject;
	private var bottomEdge:GameObject; 
	private var mText:TextRenderer;

	private var enabled:Bool;
	private var currentEffect:String;

	public function new()
	{
		super("TestGame", 800, 500, 4, true, new Color(255, 255, 100));

		this.groundY = 240;
		this.enabled = false;
		this.toggle();
		this.currentEffect = "";

		this.inputManager.registerKeyEvent(Key.Shift, KeyState.Up, toggle);
		this.inputManager.registerKeyEvent(Key.One, KeyState.Up, noEffects);
		this.inputManager.registerKeyEvent(Key.Two, KeyState.Up, unsaturatedEffects);
		this.inputManager.registerKeyEvent(Key.Three, KeyState.Up, pixelatedEffects);

		this.inputManager.registerKeyEvent(Key.Esc, KeyState.Up, stopGame);

		// Image man
		imageMan = new GameObject();
		imageMan.position = new Vector2(-100, 200);
			var img:ImageRenderer = new ImageRenderer(new ImageSource("img/man.png"), 2);
			img.shadow = new Shadow(new Color(0, 0, 0, 0.5), new Vector2(15, 15), 4);
			img.rotation = Math.PI/8;
		imageMan.addComponent("image", img);
			var velo:MovementComponent = new MovementComponent();
			velo.velocity = new Vector2(1, 0);
		imageMan.addComponent("velo", velo);
		//gameObjectManager.addGameObject(imageMan);

		// Image box
		imageBox = new GameObject();
		imageBox.position = new Vector2(-50, 200);
			var img:ImageRenderer = new ImageRenderer(new ImageSource("img/jupiter.png"), 1, new Rect(0, 0, 200, 400), 1000, 1000);
			img.visible = false;
		imageBox.addComponent("image", img);
			var velo:MovementComponent = new MovementComponent();
			velo.velocity = new Vector2(0.7, 0);
		imageBox.addComponent("velo", velo);
		//gameObjectManager.addGameObject(imageBox);

		// Circle
		var grad:LinearGradient = new LinearGradient(-300, 0, 300, 0, [new ColorStop(Color.Black, 0.10), new ColorStop(Color.Blue, 0.90)]);

		circle = new CirclePlayer(this, Key.LeftArrow, Key.RightArrow, Key.UpArrow, new Color(100, 255, 255));
		circle.position = new Vector2(80, 100);
			mText = new TextRenderer("Hello World!", 2);
			mText.fontSize = 50;
			mText.fontFamily = "sans-serif";
			mText.fontWeight = FontWeight.Size(700);
			mText.strokeColor = Color.Black;
			mText.lineWidth = 1;
			mText.alpha = 0.5;
			mText.fillPattern = new Pattern(new ImageSource("img/patternA.png"), PatternOption.Repeat);
			mText.fillGradient = grad;
			mText.strokeGradient = grad;
		circle.addComponent("text", mText);
		
		circle2 = new CirclePlayer(this, Key.A, Key.D, Key.W, new Color(255, 100, 100));
		circle2.position = new Vector2(80, 100);

		circle.friend = circle2;
		circle2.friend = circle;

		bottomEdge = new GameObject();
		bottomEdge.position = new Vector2(this.width/2, this.height - this.groundHeight/2);
			var rect:RectangleRenderer = new RectangleRenderer(this.width, this.groundHeight, 2);
			rect.fillColor = new Color(0, 100, 100);
			rect.strokeColor = Color.Grey;
			rect.lineWidth = 10;
		bottomEdge.addComponent("mainRect", rect);

		gameObjectManager.addGameObjects([imageMan, imageBox, circle, circle2, bottomEdge]);

		for (i in 0...10)
		{
			for (j in 0...10)
			{
				gameObjectManager.addGameObject(new CircleObj(new Circle(20, new Vector2(40 + (100 *i), 40 + (100*j))), Color.Black));
			}
		}

		var collisionManager:CollisionComponentManager = cast(gameObjectManager.getManager(CollisionComponentManager), CollisionComponentManager);
		collisionManager.getLayer("main").getGroup("onlyGroup").addCollidingGroup("onlyGroup");
	}

	private function toggle():Void
	{
		if (this.enabled)
		{
			this.inputManager.unregisterMouseWheelEvent(mouseWheel);
			this.inputManager.unregisterMouseButtonEvent(MouseButton.Left, MouseButtonState.Down, mouseDown);
			//this.inputManager.unregisterMouseButtonEvent(MouseButton.Left, MouseButtonState.Held, mouseHeld);
			this.inputManager.unregisterMouseButtonEvent(MouseButton.Left, MouseButtonState.Up, mouseUp);
			this.inputManager.unregisterMouseMoveEvent(mouseHeld);
		}
		else
		{
			this.inputManager.registerMouseWheelEvent(mouseWheel);
			this.inputManager.registerMouseButtonEvent(MouseButton.Left, MouseButtonState.Down, mouseDown);
			//this.inputManager.registerMouseButtonEvent(MouseButton.Left, MouseButtonState.Held, mouseHeld);
			this.inputManager.registerMouseButtonEvent(MouseButton.Left, MouseButtonState.Up, mouseUp);
			this.inputManager.registerMouseMoveEvent(mouseHeld);
		}

		this.enabled = !this.enabled;
	}

	private function removeCurrentEffect():Void
	{
		if (currentEffect != "")
		{
			cast(circle.getComponent("mainCircle"), RendererComponent).removeEffect(currentEffect);
			cast(circle2.getComponent("mainCircle"), RendererComponent).removeEffect(currentEffect);

			//cast(imageBox.getComponent("image"), RendererComponent).removeEffect(currentEffect);
			mText.removeEffect(currentEffect);
		}
	}

	private function noEffects():Void
	{
		if (currentEffect != "")
		{
			removeCurrentEffect();
			currentEffect = "";
		}
	}

	private function unsaturatedEffects():Void
	{
		if (currentEffect != "unsat")
		{
			removeCurrentEffect();

			cast(circle.getComponent("mainCircle"), RendererComponent).addEffect("unsat", new UnsaturateEffect());
			cast(circle2.getComponent("mainCircle"), RendererComponent).addEffect("unsat", new UnsaturateEffect());

			//cast(imageMan.getComponent("image"), RendererComponent).addEffect("unsat", new UnsaturateEffect());
			mText.addEffect("unsat", new UnsaturateEffect());

			currentEffect = "unsat";
		}
	}

	private function pixelatedEffects():Void
	{
		if (currentEffect != "pixel")
		{
			removeCurrentEffect();

			cast(circle.getComponent("mainCircle"), RendererComponent).addEffect("pixel", new PixelatedEffect(10));
			cast(circle2.getComponent("mainCircle"), RendererComponent).addEffect("pixel", new PixelatedEffect(10));

			//cast(imageBox.getComponent("image"), RendererComponent).addEffect("pixel", new PixelatedEffect(10));
			mText.addEffect("pixel", new PixelatedEffect(10));

			currentEffect = "pixel";
		}
	}

	private function mouseDown(mousePos:Vector2):Void
	{
		cast(bottomEdge.getComponent("mainRect"), RectangleRenderer).fillColor = new Color(200, 100, 100);

		this.lastDrag = mousePos;
	}

	private function mouseHeld(mousePos:Vector2):Void
	{
		if (inputManager.isMouseButtonDown(MouseButton.Left))
		{
			groundY += mousePos.y - this.lastDrag.y;
			this.updateGround();

			this.lastDrag = mousePos;
		}
	}

	private function mouseUp(mousePos:Vector2):Void
	{
		groundY += mousePos.y - this.lastDrag.y;
		this.updateGround();

		cast(bottomEdge.getComponent("mainRect"), RectangleRenderer).fillColor = new Color(0, 100, 100);
	}

	private function mouseWheel(ticks:Int):Void
	{
		groundY += ticks * 4;
		this.updateGround();
	}

	private function updateGround():Void
	{
		cast(bottomEdge.getComponent("mainRect"), RectangleRenderer).height = this.groundHeight;
		bottomEdge.position.y = this.height - this.groundHeight/2;
	}

	override public function destroy():Void
	{
		super.destroy();

		lastDrag = null;

		circle = null;
		circle2 = null;
		bottomEdge = null;
		imageMan = null;
		imageBox = null;
	}
}
