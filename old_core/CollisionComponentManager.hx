package titanium_reindeer;

class CollisionComponentManager extends ComponentManager
{
	private var collisionLayers:Hash<CollisionLayer>;

	public var mouseRegionManager(default, null):MouseRegionManager;

	public function new(scene:Scene)
	{
		super(scene);

		this.collisionLayers = new Hash();

		this.mouseRegionManager = new MouseRegionManager(this);
	}

	public function getLayer(layerName:String):CollisionLayer
	{
		if (collisionLayers.exists(layerName))
			return collisionLayers.get(layerName);
		else
		{
			var layer:CollisionLayer = new CollisionLayer(this, layerName);
			this.collisionLayers.set(layerName, layer);
			return layer;
		}
	}

	public function getComponent(id:Int):CollisionComponent
	{
		return cast(super.getObject(id), CollisionComponent);
	}
	
	override public function removeComponent(component:Component):Void
	{
		var collisionComp:CollisionComponent = cast(component, CollisionComponent);
		getLayer(collisionComp.layerName).removeComponent(collisionComp);
	}

	override public function update(msTimeStep:Int):Void
	{
		for (layer in this.collisionLayers)
		{
			layer.update();
		}
	}

	override public function removeComponents():Void
	{
		this.mouseRegionManager.removeHandlers();
	}

	override public function finalDestroy():Void
	{
		this.mouseRegionManager.destroy();
		this.mouseRegionManager = null;

		for (layerName in this.collisionLayers.keys())
		{
			this.collisionLayers.get(layerName).destroy();
			this.collisionLayers.remove(layerName);
		}

		super.finalDestroy();
	}
}
