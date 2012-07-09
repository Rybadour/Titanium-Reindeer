import titanium_reindeer.Game;

class TestGame extends Game
{
	public static function main():Void
	{
		var game:TestGame = new TestGame();
		game.play();
	}

	public var testScene:TestScene;

	public function new()
	{
		super("TestGame", 2000, 2000, true);

		this.testScene = new TestScene(this);
	}
}
