package titanium_reindeer;

class GameObject extends ManagedObject
{
	public var objectManager(getManager, null):GameObjectManager;
	public function getManager():GameObjectManager
	{
		if (this.manager == null)
			return null;
		else
			return cast(this.manager, GameObjectManager);
	}

	private var components:Hash<Component>;
	private var componentsToRemove:Array<String>;

	private var watchedPosition:WatchedVector2;

	public var position(getPosition, setPosition):Vector2;
	private function getPosition():Vector2
	{
		return watchedPosition;
	}
	private function setPosition(value:Vector2):Vector2
	{
		if (value != null)
		{
			if ( watchedPosition != value && !watchedPosition.equal(value) )
			{
				watchedPosition.setVector2(value);
			}
		}

		return position;
	}

	// Constructor
	public function new()
	{
		super();

		this.watchedPosition = new WatchedVector2(0, 0, positionChanged);

		this.components = new Hash();
	}

	public function update(msTimeStep:Int):Void { }

	// External
	public function addComponent(name:String, component:Component):Void
	{
		if (components.exists(name))
		{
			throw "GameObject: Attempting to add a component while the name '"+name+"' is already in use!";
			return;
		}

		this.components.set(name, component);
		component.setOwner(this);

		if (this.objectManager != null)
		{
			this.objectManager.delegateComponent(component);
		}
	}

	// External
	public function removeComponent(name:String):Void
	{
		if (components.exists(name))
		{
			if (componentsToRemove == null)
				componentsToRemove = new Array();

			componentsToRemove.push(name);
			components.get(name).remove();
		}
	}

	// External
	public function getComponent(name:String):Component
	{
		if (components.exists(name))
		{
			return components.get(name);
		}
		return null;
	}

	// A function safe for overriding
	private function positionHasChanged():Void
	{
	}

	private function positionChanged():Void
	{
		this.positionHasChanged();
		this.notifyPositionChanged();
	}

	private function notifyPositionChanged():Void
	{
		if (components != null)
		{
			for (component in components)
				component.notifyPositionChange();
		}
	}

	// A function safe for overriding, called when manager is finally set
	private function hasInitialized():Void
	{
	}

	// Internal Only
	override public function setManager(manager:ObjectManager):Void
	{
		super.setManager(manager);

		for (component in components)
		{
			this.objectManager.delegateComponent(component);
		}

		this.hasInitialized();
	}

	// Internal Only
	public function remove():Void
	{
		if (componentsToRemove == null)
			componentsToRemove = new Array();
		
		for (compName in components.keys())
		{
			componentsToRemove.push(compName);
			components.get(compName).remove();
		}
	}

	// Internal Only
	public function removeComponents():Void
	{
		if (componentsToRemove != null)
		{
			for (compName in componentsToRemove)
			{
				components.remove(compName);
			}
		}
	}

	// A function of convenience for the common use case that components are
	// just going to be destroyed and removed during destruction
	private function flushAndDestroyComponents():Void
	{
		if (components != null)
		{
			for (component in components)
				component.destroy();

			for (i in components.keys())
				components.remove(i);
		}
	}
	
	override public function finalDestroy():Void
	{
		super.finalDestroy();

		if (componentsToRemove != null)
		{
			while (componentsToRemove.length != 0)
			{
				componentsToRemove.pop();
			}
			componentsToRemove = null;
		}

		if (components != null)
		{
			for (i in components.keys())
			{
				components.remove(i);
			}
			components = null;
		}

		watchedPosition.destroy();
		watchedPosition = null;
	}
}
