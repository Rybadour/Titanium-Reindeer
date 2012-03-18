import titanium_reindeer.Scene;
import titanium_reindeer.Circle;
import titanium_reindeer.GameObject;
import titanium_reindeer.Color;
import titanium_reindeer.SpriteRenderer;
import titanium_reindeer.ImageSource;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.Vector2;

class Man extends GameObject
{
	public var motion:MovementComponent;
	public var sprite:SpriteRenderer;

	public function new(scene:Scene)
	{
		super(scene);

		this.motion = new MovementComponent( new Vector2(60, 0) );
		this.addComponent("motion", this.motion);

		/* *
		this.sprite = new SpriteRenderer( new ImageSource("img/man_sheet.png"), Layers.SPRITES, 30, 100 );
		this.sprite.addAnimation("walk", [0, 1, 2, 3, 4], 4);
		this.addComponent("sprite", this.sprite);
		/* */

		/* */
		this.sprite = new SpriteRenderer( new ImageSource("img/megaman_sheet.png"), Layers.SPRITES, 45, 37, 90, 74 );
		this.sprite.addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10);
		this.addComponent("sprite", this.sprite);
		/* */

		this.sprite.play("walk", false);
	}
}
