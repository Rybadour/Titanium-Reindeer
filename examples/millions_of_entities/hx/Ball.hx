import titanium_reindeer.GameObject;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.CollisionCircle;
import titanium_reindeer.MouseRegionHandler;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.Enums;

class Ball extends GameObject
{
	public static inline var RADIUS:Int = 10;
	private var body:CircleRenderer;
	private var collision:CollisionCircle;
	private var clickRegion:MouseRegionHandler;

	private var color:Color;

	public function new(scene:TestScene, color:Color)
	{
		super(scene);

		this.color = color;

		this.body = new CircleRenderer(RADIUS, Layers.Balls);
		this.body.fillColor = color;
		this.addComponent("body", this.body);

		this.collision = new CollisionCircle(RADIUS, "main", "balls");
		this.addComponent("collision", this.collision);

		this.clickRegion = cast(this.scene.getManager(CollisionComponentManager), CollisionComponentManager).mouseRegionManager.getHandler(this.collision);
		this.clickRegion.registerMouseMoveEvent(MouseRegionMoveEvent.Enter, mouseEnter);
		this.clickRegion.registerMouseMoveEvent(MouseRegionMoveEvent.Exit, mouseExit);
		this.clickRegion.registerMouseButtonEvent(MouseRegionButtonEvent.Click, mouseClick);
	}

	private function mouseEnter(pos:Vector2):Void
	{
		this.body.fillColor = Color.White;
	}

	private function mouseExit(pos:Vector2):Void
	{
		this.body.fillColor = this.color;
	}

	private function mouseClick(pos:Vector2, button:MouseButton):Void
	{
		this.body.fillColor = Color.Black;
	}
}
