import js.Dom;

import titanium_reindeer.core.Scene;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class TestGame
{
	public static function main():Void
	{
		var game:TestGame = new TestGame();
		game.play();
	}

    private var provider:Provider;
	public var scene:RenderScene;

	private var a:Thing;

	public function new()
	{
		var parentDom:HtmlDom = js.Lib.document.getElementById("TestGame");

		this.provider = new Provider();
		this.scene = new RenderScene(this.provider, parentDom);

        this.a = new Thing(this.scene);
	}

	public function play():Void
	{
		this.scene.updater.update(10);
	}
}
