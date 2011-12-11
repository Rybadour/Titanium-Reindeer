package titanium_reindeer;

class CollisionComponent extends Component
{
	public var collisionManager(getCollisionManager, null):CollisionComponentManager;
	public function getCollisionManager():CollisionComponentManager
	{
		if (this.manager == null)
			return null;
		else
			return cast(this.manager, CollisionComponentManager);
	}

	private var minBoundingRect:Rect;
	public function getMinBoundingRect():Rect
	{
		return this.minBoundingRect.getCopy();
	}
	
	public var width(default, setWidth):Float;
	private function setWidth(value:Float):Float
	{
		this.width = value;
		this.updateBounds();
		return this.width;
	}
	public var height(default, setHeight):Float;
	private function setHeight(value:Float):Float
	{
		this.height = value;
		this.updateBounds();
		return this.height;
	}

	private var watchedOffset:WatchedVector2;
	public var offset(getOffset, setOffset):Vector2;
	private function getOffset():Vector2
	{
		return this.watchedOffset;
	}
	private function setOffset(value:Vector2):Vector2
	{
		if ( value != null )
		{
			if ( this.watchedOffset != value && !this.watchedOffset.equal(value) )
			{
				this.watchedOffset.setVector2(value);
				this.updateBounds();
			}
		}

		return offset;
	}

	private var allowUpdateBounds:Bool;

	public function getCenter():Vector2
	{
		return this.owner.position.add(this.offset);
	}

	public var layerName(default, null):String;
	public var groupName(default, null):String;

	private var registeredCallbacks:Array<CollisionComponent -> Void>;

	public function new(width:Float, height:Float, layer:String, group:String)
	{
		super();
	
		this.width = width;
		this.height = height;
		this.watchedOffset = new WatchedVector2(0, 0, offsetChanged);

		this.layerName = layer;
		this.groupName = group;	

		this.allowUpdateBounds = true;

		registeredCallbacks = new Array();
	}

	public function collide(otherCompId:Int):Void
	{
		var otherComp:CollisionComponent = this.collisionManager.getComponent(otherCompId);
		if (otherComp == null)
			return;

		for (func in registeredCallbacks)
		{
			func(otherComp);
		}
	}

	public function registerCallback(func:CollisionComponent -> Void):Void
	{
		if (func != null)
			registeredCallbacks.push(func);
	}

	public function unregisterCallback(func:CollisionComponent -> Void):Void
	{
		if (func == null)
			return;

		for (i in 0...registeredCallbacks.length)
		{
			// A pretty neat way of ensuring that i doesn't skip over the next element if a found method was spliced
			// because indexes are then moved down
			while (i < registeredCallbacks.length)
			{
				if (Reflect.compareMethods(registeredCallbacks[i], func))
					registeredCallbacks.splice(i, 1);
				else
					break;
			}
		}
	}

	public function isPointIntersecting(point:Vector2):Bool
	{
		return true;
	}
	
	override public function setOwner(gameObject:GameObject):Void
	{
		super.setOwner(gameObject);

		this.updateBounds();
	}

	override public function getManagerType():Class<ComponentManager>
	{
		return CollisionComponentManager;
	}

	override public function initialize():Void
	{
		// Component Manager is finally tied in
		var layer:CollisionLayer = this.collisionManager.getLayer(layerName);
		layer.addComponent(this);
	}

	override public function notifyPositionChange():Void
	{
		updateBounds();
	}

	private function offsetChanged():Void
	{
		this.updateBounds();
	}

	private function updateBounds():Void
	{
		if (!this.allowUpdateBounds)
			return;

		if (this.owner != null)
		{
			this.minBoundingRect = new Rect(
				this.owner.position.x + this.offset.x - this.width/2,
				this.owner.position.y + this.offset.y - this.height/2,
				this.width,
				this.height
			);
		}

		if (this.collisionManager != null)
		{
			var layer:CollisionLayer = this.collisionManager.getLayer(layerName);
			layer.updateComponent(this);
		}
	}

	override public function destroy():Void
	{
		super.destroy();
	}
}
