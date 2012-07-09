import titanium_reindeer.Game;
import titanium_reindeer.GameObject;
import titanium_reindeer.Scene;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;
import titanium_reindeer.RendererComponent;
import titanium_reindeer.InputManager;
import titanium_reindeer.ImageRenderer;
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

class TestScene extends Scene
{
	public var testGame:TestGame;

	private var balls:Array<Ball>;

	public function new(game:TestGame)
	{
		super(game, "testScene", 0, Layers.NUM_LAYERS, Color.White);

		this.testGame = game;
		this.balls = new Array();

		var colors:Array<Color> = [Color.Red, Color.Orange, Color.Yellow, Color.Green, Color.Blue, Color.Purple];

		var spacing:Float = (Ball.RADIUS*2) + 2;
		for (x in 1...20)
		{
			for (y in 1...20)
			{
				var ball:Ball = new Ball(this, colors[Std.random(colors.length)]);
				ball.position = new Vector2(x*spacing, y*spacing);
				this.balls.push(ball);
			}
		}
	}
}
