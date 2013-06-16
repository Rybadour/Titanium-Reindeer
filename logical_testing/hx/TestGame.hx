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

	private var d:Ball;
	private var e:Ball;

	private var l:Line;

	public function new()
	{
		var parentDom:HtmlDom = js.Lib.document.getElementById("TestGame");

		this.provider = new Provider();
		this.scene = new RenderScene(this.provider, parentDom);

		this.d = new Ball(this.scene, Color.Orange, 50, "others");
		this.d.body.state.localPosition = new Vector2(100, 120);

		this.l = new Line(this.scene, new Vector2(100, 100), "others");
		this.l.body.state.localPosition = new Vector2(50, 120);
		this.l.body.strokeFillState.lineWidth = 10;
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
		this.scene.updater.update(10);

		this.play();
	}
}
