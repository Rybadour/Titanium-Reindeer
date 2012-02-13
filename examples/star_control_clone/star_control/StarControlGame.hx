package star_control;

import titanium_reindeer.Game;
import titanium_reindeer.Scene;
import titanium_reindeer.Rect;

class StarControlGame extends Game
{
	public static inline var IMAGE_BASE 	= "img/";
	public static inline var FIELD_SIZE 	= 600;
	public static inline var OFFSCREEN_EDGE = 30;

	public static function getFieldRect():Rect
	{
		return new Rect(-OFFSCREEN_EDGE,
					-OFFSCREEN_EDGE,
					FIELD_SIZE + OFFSCREEN_EDGE*2,
					FIELD_SIZE + OFFSCREEN_EDGE*2);
	}

	public var battleScene(default, null):BattleScene;
	public var menuScene(default, null):MenuScene;

	public function new()
	{
		super("TestGame", FIELD_SIZE + UiBar.WIDTH, FIELD_SIZE, true);

		this.menuScene = new MenuScene(this);
		this.battleScene = new BattleScene(this);

		// Set the global sound volume to a reasonable level
		this.soundManager.globalVolume = 0.2;
	}
}

