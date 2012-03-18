import titanium_reindeer.Game;
import titanium_reindeer.Scene;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class TestGame extends Game
{
	public static function main():Void
	{
		var game:TestGame = new TestGame();
		game.play();
	}

    
	public var globalScene:Scene;
    public var thing:Thing;

	public function new()
	{
		super("TestGame", 800, 500, true);

		this.globalScene = new Scene(this, "globalScene", 0, Layers.NUM_LAYERS, Color.Black);

        this.thing = new Thing(this.globalScene);
		this.thing.position = new Vector2(200, 200);

		var collisionManager:CollisionComponentManager = cast(this.globalScene.getManager(CollisionComponentManager), CollisionComponentManager);
		collisionManager.getLayer("main").getGroup("onlyGroup").addCollidingGroup("onlyGroup");
	}
}
