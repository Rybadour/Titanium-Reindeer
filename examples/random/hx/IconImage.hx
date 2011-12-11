import titanium_reindeer.GameObject;
import titanium_reindeer.ImageSource;
import titanium_reindeer.ImageRenderer;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.Vector2;

class IconImage extends GameObject
{
	private var bottom:Float;
	private var right:Float;

	public function new(bottom:Float, right:Float)
	{
		super();

		this.bottom = bottom;
		this.right = right;

		this.position = new Vector2(Math.random() * this.right, Math.random() * this.bottom);

		var image:ImageRenderer = new ImageRenderer(new ImageSource("img/patternA.png"), 0);
		this.addComponent("image", image);

		var movement:MovementComponent = new MovementComponent(new Vector2(Math.random() * 2, Math.random() *2));
		this.addComponent("movement", movement);
	}

	override public function update():Void
	{
		if (this.position.y < 0)
			this.position.y = bottom;
		else if (this.position.y > bottom)
			this.position.y = 0;
			
		if (this.position.x < 0)
		 	this.position.x = right;
		else if (this.position.x > right)
		 	this.position.x = 0;
	}
}
