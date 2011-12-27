package star_control;

import titanium_reindeer.GameObject;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.TextRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;
import titanium_reindeer.ObjectManager;
import titanium_reindeer.LineRenderer;

class UiBar extends GameObject
{
	public static inline var WIDTH = 100;
	public static inline var HEIGHT = StarControlGame.FIELD_SIZE;

	private var background:RectRenderer;
	private var p1Title:TextRenderer;
	private var p2Title:TextRenderer;

	private var p1Score:TextRenderer;
	private var p2Score:TextRenderer;

	private var divideLine:LineRenderer;

	public var ship1Ui(default, null):ShipUi;
	public var ship2Ui(default, null):ShipUi;

	public function new(pos:Vector2)
	{
		super();

		this.position = pos.add( new Vector2(WIDTH/2, HEIGHT/2) );

		this.background = new RectRenderer(WIDTH, HEIGHT, Layers.UI_A);
		this.background.fillColor = Color.Grey;
		this.background.strokeColor = Color.Black;
		this.background.lineWidth = 2;
		this.addComponent("background", this.background);

		this.p1Title = new TextRenderer("Player 1", Layers.UI_B);
		this.p1Title.fillColor = StarControlGame.PLAYER1_COLOR;
		this.p1Title.strokeColor = Color.Black;
		this.p1Title.lineWidth = 1;
		this.p1Title.fontSize = 22;
		this.p1Title.fontWeight = FontWeight.Bold;
		this.p1Title.offset = new Vector2(0, 80 - HEIGHT/2);
		this.addComponent("p1Title", p1Title);

		this.p2Title = new TextRenderer("Player 2", Layers.UI_B);
		this.p2Title.fillColor = StarControlGame.PLAYER2_COLOR;
		this.p2Title.strokeColor = Color.Black;
		this.p2Title.lineWidth = 1;
		this.p2Title.fontSize = 22;
		this.p2Title.fontWeight = FontWeight.Bold;
		this.p2Title.offset = new Vector2(0, HEIGHT/2 - 100 - ShipUi.HEIGHT - 20);
		this.addComponent("p2Title", p2Title);

		this.p1Score = new TextRenderer("0", Layers.UI_B);
		this.p1Score.fillColor = StarControlGame.PLAYER1_COLOR;
		this.p1Score.strokeColor = Color.Black;
		this.p1Score.lineWidth = 1;
		this.p1Score.fontSize = 22;
		this.p1Score.fontWeight = FontWeight.Bold;
		this.p1Score.offset = new Vector2(0, -20);
		this.addComponent("p1Score", p1Score);

		this.p2Score = new TextRenderer("0", Layers.UI_B);
		this.p2Score.fillColor = StarControlGame.PLAYER2_COLOR;
		this.p2Score.strokeColor = Color.Black;
		this.p2Score.lineWidth = 1;
		this.p2Score.fontSize = 22;
		this.p2Score.fontWeight = FontWeight.Bold;
		this.p2Score.offset = new Vector2(0, 20);
		this.addComponent("p2Score", p2Score);

		this.divideLine = new LineRenderer(new Vector2(WIDTH, 0), Layers.UI_B);
		this.divideLine.offset = new Vector2(-WIDTH/2, 0);
		this.divideLine.lineWidth = 4;
		this.divideLine.strokeColor = Color.Black;
		this.addComponent("divideLine", this.divideLine);

		var shipUiMargin:Float = (WIDTH - ShipUi.WIDTH)/2;

		this.ship1Ui = new ShipUi();
		this.ship1Ui.position = pos.add(new Vector2(ShipUi.WIDTH/2 + shipUiMargin, ShipUi.HEIGHT/2 + 100));

		this.ship2Ui = new ShipUi();
		this.ship2Ui.position = pos.add(new Vector2(ShipUi.WIDTH/2 + shipUiMargin, HEIGHT - 100 - ShipUi.HEIGHT/2));
	}

	public function updateScore(p1Score:Int, p2Score:Int):Void
	{
		this.p1Score.text = p1Score+"";
		this.p2Score.text = p2Score+"";
	}

	public override function setManager(manager:ObjectManager):Void
	{
		super.setManager(manager);

		this.objectManager.addGameObject(ship1Ui);

		this.objectManager.addGameObject(ship2Ui);
	}
}
