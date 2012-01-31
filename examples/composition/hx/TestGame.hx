import titanium_reindeer.Game;
import titanium_reindeer.GameObject;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;
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

    
    public var thing:Thing;

	public function new()
	{
		super("TestGame", 800, 500, Layers.NUM_LAYERS, true, Color.Black);

        this.thing = new Thing();
		this.thing.position = new Vector2(200, 200);
        this.gameObjectManager.addGameObject(this.thing);

		var collisionManager:CollisionComponentManager = cast(gameObjectManager.getManager(CollisionComponentManager), CollisionComponentManager);
		collisionManager.getLayer("main").getGroup("onlyGroup").addCollidingGroup("onlyGroup");
	}
}
