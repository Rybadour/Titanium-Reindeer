package star_control;

import titanium_reindeer.Scene;
import titanium_reindeer.ui.RectButton;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.Enums;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.RendererComponentManager;

class BattleScene extends Scene
{
	// Render layers for this scene
	public static inline var BACKGROUND_LAYER:Int 	= 0;
	public static inline var BELOW_SHIPS_LAYER:Int	= 1;
	public static inline var SHIPS_LAYER:Int 		= 2;
	public static inline var UI_A_LAYER:Int 		= 3;
	public static inline var UI_B_LAYER:Int 		= 4;
	public static inline var UI_C_LAYER:Int 		= 5;
	public static inline var TOP_LAYER:Int 			= 6;
	public static inline var NUM_LAYERS:Int 		= 7;

	public static inline var PLAYER1_COLOR 	= new Color(0, 162, 232);
	public static inline var PLAYER2_COLOR 	= new Color(193, 29, 37);

	private var starControlGame:StarControlGame;

	private var player1:Player;
	private var player2:Player;

	private var ui:UiBar;

	private var player1Score:Int;
	private var player2Score:Int;

	public function new(game:StarControlGame)
	{
		super(game, "battleScene", 0, NUM_LAYERS, Color.Black);

		this.starControlGame = game;

		this.player1Score = 0;
		this.player2Score = 0;

		this.ui = new UiBar(this, new Vector2(StarControlGame.FIELD_SIZE, 0));

		// Player 1
		var ship1:Ship = new Fighter(this, true, this.ui.ship1Ui);
		ship1.position = new Vector2(50, 50);
		this.player1 = new Player(this, ship1, Key.W, Key.D, Key.A, Key.Q);

		// Player 2
		var ship2:Ship = new Artillery(this, false, this.ui.ship2Ui);
		ship2.position = new Vector2(550, 550);
		this.player2 = new Player(this, ship2, Key.UpArrow, Key.RightArrow, Key.LeftArrow, Key.Period);

		// Setup collision groups
		var collisionManager:CollisionComponentManager = cast(this.getManager(CollisionComponentManager), CollisionComponentManager);
		collisionManager.getLayer("main").getGroup(CollisionGroups.SHIPS).addCollidingGroup(CollisionGroups.SHIPS);
		collisionManager.getLayer("main").getGroup(CollisionGroups.SHIPS).addCollidingGroup(CollisionGroups.BULLETS);
		collisionManager.getLayer("main").getGroup(CollisionGroups.BULLETS).addCollidingGroup(CollisionGroups.SHIPS);
		//collisionManager.getLayer("main").enableDebugView("debugCanvas", new Vector2(OFFSCREEN_EDGE + 20, OFFSCREEN_EDGE + 20));

		this.game.inputManager.registerKeyEvent(Key.Space, KeyState.Up, pauseButton);
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

		var rendererManager:RendererComponentManager = cast(this.getManager(RendererComponentManager), RendererComponentManager);
		rendererManager.renderLayerManager.getLayer(SHIPS_LAYER).redrawBackground = true;
	}

	private function pauseButton():Void
	{
		this.starControlGame.startMenu();
	}
}
