package star_control;

import titanium_reindeer.Game;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.Enums;
import titanium_reindeer.Rect;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.RendererComponentManager;

class StarControlGame extends Game
{
	public static inline var IMAGE_BASE 	= "img/";
	public static inline var FIELD_SIZE 	= 600;
	public static inline var OFFSCREEN_EDGE = 30;

	public static inline var PLAYER1_COLOR 	= new Color(0, 162, 232);
	public static inline var PLAYER2_COLOR 	= new Color(193, 29, 37);

	public static function getFieldRect():Rect
	{
		return new Rect(-OFFSCREEN_EDGE,
					-OFFSCREEN_EDGE,
					FIELD_SIZE + OFFSCREEN_EDGE*2,
					FIELD_SIZE + OFFSCREEN_EDGE*2);
	}

	private var player1:Player;
	private var player2:Player;

	private var ui:UiBar;

	private var player1Score:Int;
	private var player2Score:Int;

	public function new()
	{
		super("TestGame", FIELD_SIZE + UiBar.WIDTH, FIELD_SIZE, Layers.NUM_LAYERS, true, Color.Black);

		this.player1Score = 0;
		this.player2Score = 0;

		this.ui = new UiBar(this.globalScene, new Vector2(FIELD_SIZE, 0));

		// Player 1
		var ship1:Ship = new Fighter(this.globalScene, true, this.ui.ship1Ui);
		ship1.position = new Vector2(50, 50);

		this.player1 = new Player(this, ship1, Key.W, Key.D, Key.A, Key.Q);

		// Player 2
		var ship2:Ship = new Artillery(this.globalScene, false, this.ui.ship2Ui);
		ship2.position = new Vector2(550, 550);

		this.player2 = new Player(this, ship2, Key.UpArrow, Key.RightArrow, Key.LeftArrow, Key.Period);


		// Setup collision groups
		var collisionManager:CollisionComponentManager = cast(this.globalScene.getManager(CollisionComponentManager), CollisionComponentManager);
		collisionManager.getLayer("main").getGroup(CollisionGroups.SHIPS).addCollidingGroup(CollisionGroups.SHIPS);
		collisionManager.getLayer("main").getGroup(CollisionGroups.SHIPS).addCollidingGroup(CollisionGroups.BULLETS);
		collisionManager.getLayer("main").getGroup(CollisionGroups.BULLETS).addCollidingGroup(CollisionGroups.SHIPS);

		//collisionManager.getLayer("main").enableDebugView("debugCanvas", new Vector2(OFFSCREEN_EDGE + 20, OFFSCREEN_EDGE + 20));

		// Set the global sound volume to a reasonable level
		this.soundManager.globalVolume = 0.2;
	}

	public function notifyShipDied(player:Player):Void
	{
		if (player1 == player)
			player2Score++;
		else
			player1Score++;

		this.player1.ship.reset(new Vector2(50, 50));

		this.player2.ship.reset(new Vector2(550, 550));

		this.ui.updateScore(this.player1Score, this.player2Score);

		var rendererManager:RendererComponentManager = cast(this.globalScene.getManager(RendererComponentManager), RendererComponentManager);
		rendererManager.renderLayerManager.getLayer(Layers.SHIPS).redrawBackground = true;
	}
}

