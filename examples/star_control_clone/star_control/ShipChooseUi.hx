package star_control;

import titanium_reindeer.GameObject;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.ImageRenderer;
import titanium_reindeer.TextRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;
import titanium_reindeer.ObjectManager;
import titanium_reindeer.LineRenderer;

class ShipChooseUi extends GameObject
{
	public static inline var WIDTH 	= 200;
	public static inline var HEIGHT = 200;

	private var title:TextRenderer;
	private var background:RectRenderer;
	private var shipIcons:Array<ImageRenderer>;

	private var game:StarControlGame;

	public function new(game:StarControlGame)
	{
		this.game = game;
	}
}
