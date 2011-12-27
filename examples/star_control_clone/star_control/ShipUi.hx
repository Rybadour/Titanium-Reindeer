package star_control;

import titanium_reindeer.GameObject;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.Color;

class ShipUi extends GameObject
{
	public static inline var WIDTH 			= 72;
	public static inline var HEIGHT 		= 86;
	public static inline var START_X 		= -WIDTH/2;
	public static inline var START_Y 		= -HEIGHT/2;

	public static inline var BAR_WIDTH		= 12;
	public static inline var BAR_HEIGHT		= 6;

	private static inline var HEALTH_FILLED = new Color(34, 255, 51);
	private static inline var HEALTH_EMPTY 	= new Color(34, 34, 34);

	private static inline var AMMO_FILLED 	= new Color(255, 0, 17);
	private static inline var AMMO_EMPTY 	= new Color(34, 34, 34);

	private var background:RectRenderer;
	private var healthBars:Array<RectRenderer>;
	private var ammoBars:Array<RectRenderer>;

	private var maxHealth:Int;
	private var maxAmmo:Int;

	private var lastHealth:Int;
	private var lastAmmo:Int;

	public function new()
	{
		super();

		this.background = new RectRenderer(WIDTH, HEIGHT, Layers.UI_B);
		this.background.fillColor = Color.Grey;
		this.background.strokeColor = Color.Black;
		this.background.lineWidth = 2;
		this.addComponent("background", this.background);

		this.maxHealth = 0;
		this.maxAmmo = 0;
	}

	public function initialize(maxHealth:Int, maxAmmo:Int):Void
	{
		this.maxHealth = Math.round( Math.max(0, Math.min(maxHealth, 20)) );
		this.maxAmmo = Math.round( Math.max(0, Math.min(maxAmmo, 20)) );

		this.healthBars = new Array();
		for (i in 0...this.maxHealth)
		{
			var healthBar:RectRenderer = new RectRenderer(12, 6, Layers.UI_C);
			healthBar.fillColor = HEALTH_FILLED;
			healthBar.strokeColor = Color.Black;
			healthBar.lineWidth = 2;

			var x:Int = 4;
			if (i > 9)
				x += BAR_WIDTH + 4;
			var y:Int = 4 + (i%10)*8;
			healthBar.offset = new Vector2(START_X + BAR_WIDTH/2 + x, START_Y + BAR_HEIGHT/2 + y);

			this.healthBars[i] = healthBar;
			this.addComponent("healthBar_"+i, healthBar);
		}
		this.lastHealth = this.maxHealth;

		this.ammoBars = new Array();
		for (i in 0...this.maxAmmo)
		{
			var ammoBar:RectRenderer = new RectRenderer(12, 6, Layers.UI_C);
			ammoBar.fillColor = AMMO_FILLED;
			ammoBar.strokeColor = Color.Black;
			ammoBar.lineWidth = 2;

			var x:Int = 4;
			if (i > 9)
				x += BAR_WIDTH + 4;
			var y:Int = 4 + (i%10)*8;
			ammoBar.offset = new Vector2(START_X + BAR_WIDTH/2 + x, START_Y + BAR_HEIGHT/2 + y);
			ammoBar.offset.x += BAR_WIDTH*2 + 4 + 4 + 4;

			this.ammoBars[i] = ammoBar;
			this.addComponent("ammoBar_"+i, ammoBar);
		}
		this.lastAmmo = this.maxAmmo;
	}

	public function updateHealth(amount:Int)
	{
		amount = Math.round( Math.max(0, Math.min(amount, this.maxHealth)) );

		if (amount > this.lastHealth)
		{
			for (i in this.lastHealth...amount)
			{
				this.healthBars[i].fillColor = HEALTH_FILLED;
			}
		}
		else if (amount < this.lastHealth)
		{
			for (i in amount...this.lastHealth)
			{
				this.healthBars[i].fillColor = HEALTH_EMPTY;
			}
		}

		this.lastHealth = amount;
	}

	public function updateAmmo(amount:Int)
	{
		amount = Math.round( Math.max(0, Math.min(amount, this.maxAmmo)) );

		if (amount > this.lastAmmo)
		{
			for (i in this.lastAmmo...amount)
			{
				this.ammoBars[i].fillColor = AMMO_FILLED;
			}
		}
		else if (amount < this.lastAmmo)
		{
			for (i in amount...this.lastAmmo)
			{
				this.ammoBars[i].fillColor = AMMO_EMPTY;
			}
		}

		this.lastAmmo = amount;
	}
}
