package star_control;

import titanium_reindeer.Scene;
import titanium_reindeer.ui.RectButton;
import titanium_reindeer.GameObject;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class MenuScene extends Scene
{
	public static inline var BACK_LAYER:Int		= 0;
	public static inline var MID_LAYER:Int		= 1;
	public static inline var FORE_LAYER:Int		= 2;
	public static inline var NUM_LAYERS:Int		= 3;

	public var menuBackground:GameObject;
	public var startButton:RectButton;

	public function new(game:StarControlGame)
	{
		super(game, "menuScene", 1, NUM_LAYERS, Color.Clear);

		this.menuBackground = new GameObject(this);
		var rect:RectRenderer = new RectRenderer(120, 200, BACK_LAYER);
		rect.fillColor = Color.Blue;
		rect.strokeColor = Color.Red;
		rect.lineWidth = 2;
		this.menuBackground.addComponent("rect", rect);

		this.startButton = new RectButton(this, 100, 50, MID_LAYER, FORE_LAYER); 
	}
}
