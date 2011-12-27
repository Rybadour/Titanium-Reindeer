import titanium_reindeer.Rect;
import titanium_reindeer.GameObject;
import titanium_reindeer.Color;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.Vector2;
import titanium_reindeer.CollisionRect;
import titanium_reindeer.CollisionComponent;
import titanium_reindeer.CollisionComponentManager;
import titanium_reindeer.MouseRegionHandler;
import titanium_reindeer.ObjectManager;

class RectObj extends GameObject
{
	public var bounds(getBounds, never):Rect;
	private function getBounds():Rect
	{
		var rect:RectRenderer = cast(this.getComponent("mainRect"), RectRenderer);
		rect.rotation = Math.PI/4;
		return new Rect(position.x - rect.width/2, position.y - rect.height/2, rect.width, rect.height);
	}

	private var renderer:RectRenderer;
	private var collisionRect:CollisionRect;

	private var mouseHandler:MouseRegionHandler;

	public function new(bounds:Rect, color:Color)
	{
		super();

		this.position = new Vector2(bounds.x + bounds.width/2, bounds.y + bounds.height/2);

		this.renderer = new RectRenderer(bounds.width, bounds.height, 3);
		this.renderer.alpha = 0.3;
		this.renderer.fillColor = color;
		this.addComponent("mainRect", renderer);

		this.collisionRect = new CollisionRect(bounds.width, bounds.height, "main", "onlyGroup");
		this.collisionRect.registerCallback(collide);
		this.addComponent("collision", this.collisionRect);
	}

	override public function setManager(manager:ObjectManager):Void
	{
		super.setManager(manager);

		this.mouseHandler = cast(this.objectManager.getManager(CollisionComponentManager), CollisionComponentManager).mouseRegionManager.getHandler(this.collisionRect);
		//this.mouseHandler.registerMouseMoveEvent(MouseRegionMoveEvent.Enter, mouseEnter);
		this.mouseHandler.registerMouseMoveEvent(MouseRegionMoveEvent.Exit, mouseExit);
	}

	private function collide(other:CollisionComponent):Void
	{
		this.renderer.alpha = 1;
		//collisionComp.destroy();
	}

	public function mouseExit(mousePos:Vector2):Void
	{
		this.renderer.alpha = 0.3;
	}
}
