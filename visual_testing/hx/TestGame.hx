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
	private var b:Thing;
	private var c:Thing;

	public function new()
	{
		var parentDom:HtmlDom = js.Lib.document.getElementById("TestGame");

		this.provider = new Provider();
		this.scene = new RenderScene(this.provider, parentDom);

        this.a = new Thing(this.scene, Color.Red, 40, "things");
		this.a.body.state.localPosition.x = 30;

        this.b = new Thing(this.scene, Color.Black, 10, "things");
		this.b.body.state.localPosition.y = 120;

		this.c = new Thing(this.scene, Color.Blue, 100, "others");
		this.c.body.state.localPosition = new Vector2(70, 108);
	}

	public function play():Void
	{
		var parentDom:HtmlDom = js.Lib.document.getElementById("TestGame");
		untyped
		{
			js.Lib.window.webkitRequestAnimationFrame(loop, parentDom);
		}
	}

	public function loop():Void
	{
		this.c.body.state.localPosition.x += 0.1;
		this.b.body.state.localPosition.x += 1;
		this.scene.updater.update(10);

		this.play();
	}
}
