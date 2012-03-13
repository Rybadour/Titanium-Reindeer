import titanium_reindeer.Circle;
import titanium_reindeer.GameObject;
import titanium_reindeer.Color;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.CollisionCircle;
import titanium_reindeer.CollisionComponent;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.MouseRegionHandler;
import titanium_reindeer.ObjectManager;
import titanium_reindeer.Enums;

class CircleObj extends GameObject
{
	private var renderer:CircleRenderer;
	private var collisionCircle:CollisionCircle;

	private var mouseHandler:MouseRegionHandler;

	private var isLocked:Bool;

	public function new(bounds:Circle, color:Color)
	{
		super();

		this.position = new Vector2(bounds.center.x + bounds.radius, bounds.center.y + bounds.radius);

		this.renderer = new CircleRenderer(bounds.radius, Layers.SPRITES);
		this.renderer.alpha = 0.3;
		this.renderer.fillColor = color;
		this.addComponent("mainRect", renderer);

		this.collisionCircle = new CollisionCircle(bounds.radius, "main", "onlyGroup");
		this.collisionCircle.registerCallback(collide);
		this.addComponent("collision", this.collisionCircle);

		this.isLocked = false;
	}

	override public function setManager(manager:ObjectManager):Void
	{
		super.setManager(manager);

		this.mouseHandler = cast(this.objectManager.getManager(CollisionComponentManager), CollisionComponentManager).mouseRegionManager.getHandler(this.collisionCircle);
		this.mouseHandler.registerMouseMoveEvent(MouseRegionMoveEvent.Enter, mouseEnter);
		this.mouseHandler.registerMouseMoveEvent(MouseRegionMoveEvent.Exit, mouseExit);
		this.mouseHandler.registerMouseButtonEvent(MouseRegionButtonEvent.Click, mouseClick);
	}

	private function collide(other:CollisionComponent):Void
	{
		this.renderer.alpha = 1;
		//collisionComp.destroy();
	}

	public function mouseEnter(mousePos:Vector2):Void
	{
		if (!this.isLocked)
		{
			this.renderer.alpha = 1;
		}
	}

	public function mouseExit(mousePos:Vector2):Void
	{
		if (!this.isLocked)
		{
			this.renderer.alpha = 0.3;
		}
	}

	public function mouseClick(mousePos:Vector2, button:MouseButton):Void
	{
		this.isLocked = !this.isLocked;

		if (this.isLocked)
		{
			if (button == MouseButton.Left)
				this.renderer.alpha = 0.1;
			else if (button == MouseButton.Right)
				this.renderer.alpha = 0.8;
		}
	}
}
