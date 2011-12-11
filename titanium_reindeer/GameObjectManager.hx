package titanium_reindeer;

class GameObjectManager extends ObjectManager
{
	public var game(default, null):Game;

	private var componentManagers:Hash<ComponentManager>;

	// Constructor
	public function new(game:Game)
	{
		super();

		this.game = game;

		this.componentManagers = new Hash();
	}

	// External functions
	public function addGameObject(obj:GameObject):Void
	{
		super.addObject(obj);
	}

	public function addGameObjects(objs:Array<GameObject>):Void
	{
		for (obj in objs)
		{
			super.addObject(obj);
		}
	}

	public function removeGameObject(obj:GameObject):Void
	{
		if (super.objectIdExists(obj.id))
		{
			obj.remove();
		}

		super.removeObject(obj);
	}

	public function getGameObject(id:Int):GameObject
	{
		return cast( super.getObject(id), GameObject );
	}

	public function getManager(managerType:Class<ComponentManager>):ComponentManager
	{
		// Essentially, get the name of the class and check if we have one of these managers already
		// If we do use that one for the component's manager, otherwise make a new one and use it
		var className:String = Type.getClassName(managerType);
		var manager:ComponentManager;
		if (this.componentManagers.exists(className))
		{
			manager = this.componentManagers.get(className);
		}
		else
		{
			manager = Type.createInstance(managerType, [this]);
			this.componentManagers.set(className, manager);
		}

		return manager;
	}

	// Internal functions Only
	public function delegateComponent(component:Component)
	{
		var manager:ComponentManager = this.getManager(component.getManagerType());
		manager.addComponent(component);

		component.initialize();
	}

	public function update(msTimeStep:Int):Void
	{
		// Pre-Update on component managers
		for (manager in this.componentManagers)
		{
			manager.preUpdate(msTimeStep);
		}

		// All state change should happen here
		// Update game objects
		for (obj in objects)
		{
			cast(obj, GameObject).update(msTimeStep);
		}
		// Update on component managers
		for (manager in this.componentManagers)
		{
			manager.update(msTimeStep);
		}

		// Post-Update on component managers
		for (manager in this.componentManagers)
		{
			manager.postUpdate(msTimeStep);
		}

		// Remove Objects which were flagged to be removed
		super.removeObjects();
		// Let GameObjects remove Components they wanted to remove now (and only now)
		for (obj in objects)
		{
			cast(obj, GameObject).removeComponents();
		}
		for (manager in this.componentManagers)
		{
			manager.removeComponents();
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		for (managerName in this.componentManagers.keys())
		{
			this.componentManagers.get(managerName).destroy();
			this.componentManagers.remove(managerName);
		}
		this.componentManagers = null;

		game = null;
	}
}
