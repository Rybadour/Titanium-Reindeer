package titanium_reindeer;

class Scene extends ObjectManager
{
	public var sceneManager(default, null):SceneManager;
	public var game(getGame, null):Game;
	private function getGame():Game
	{
		return this.sceneManager.game;
	}

	private var toBeDestroyed:Bool;

	public var name(default, null):String;
	public var renderDepth(default, null):Int;
	public var layerCount(default, null):Int;
	public var backgroundColor(default, null):Color;
	public var isPaused(default, null):Bool;

	public var inputManager(default, null):SceneInputManager;
	public var soundManager(default, null):SceneSoundManager;
	public var bitmapCache(getBitmapCache, null):BitmapCache;
	public function getBitmapCache():BitmapCache
	{
		return this.game.bitmapCache;
	}

	private var lastId:Int;
	private var oldAvailableIds:Array<Int>;

	private var componentManagers:Hash<ComponentManager>;

	public function new(game:Game, name:String, renderDepth:Int, layerCount:Int, ?backgroundColor:Color)
	{
		super();

		this.name = name;
		this.inputManager = new SceneInputManager(this);
		this.soundManager = new SceneSoundManager(this);
		this.renderDepth = renderDepth;
		this.layerCount = layerCount;
		this.backgroundColor = backgroundColor == null ? new Color(255, 255, 255) : backgroundColor;
		this.isPaused = false;

		this.sceneManager = game.sceneManager;
		this.sceneManager.addScene(this);

		this.componentManagers = new Hash();
	}

	public function addGameObject(gameObject:GameObject):Void
	{
		this.addObject(gameObject);
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

	public function getImage(filePath:String):ImageSource
	{
		// append a uniqueish phrase so that name clashes with renderer identifiers are impossible
		var pathIdentifier:String = "filePath:" + filePath;

		if (this.bitmapCache.exists(pathIdentifier))
			return this.bitmapCache.get(pathIdentifier);

		var imageSource:ImageSource = new ImageSource(filePath);
		this.bitmapCache.set(pathIdentifier, imageSource);
		return imageSource;
	}

	public function getSound(filePath:String):Sound
	{
		return this.soundManager.getSound(filePath);
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

	public function pause():Void
	{
		if (!this.isPaused)
		{
			this.isPaused = true;

			this.soundManager.pause(true);
		}
	}

	public function unpause():Void
	{
		if (this.isPaused)
		{
			this.isPaused = false;

			this.soundManager.unpause();
		}
	}

	// Internal functions Only
	public function delegateComponent(component:Component)
	{
		var manager:ComponentManager = this.getManager(component.getManagerType());
		manager.addComponent(component);

		component.initialize();
	}

	public function preUpdate(msTimeStep:Int):Void
	{
		// Pre-Update on component managers
		for (manager in this.componentManagers)
		{
			manager.preUpdate(msTimeStep);
		}
		inputManager.preUpdate(msTimeStep);
	}

	public function update(msTimeStep:Int):Void
	{
		if (this.isPaused)
			return;

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
		inputManager.update(msTimeStep);
	}

	public function postUpdate(msTimeStep:Int):Void
	{
		// Post-Update on component managers
		for (manager in this.componentManagers)
		{
			manager.postUpdate(msTimeStep);
		}
		this.inputManager.postUpdate(msTimeStep);

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
		
		if (this.toBeDestroyed)
			this.finalDestroy();
	}

	public function destroy():Void
	{
		this.toBeDestroyed = true;
	}

	override public function finalDestroy():Void
	{
		super.finalDestroy();

		for (managerName in this.componentManagers.keys())
		{
			this.componentManagers.get(managerName).finalDestroy();
			this.componentManagers.remove(managerName);
		}
		this.componentManagers = null;

		this.sceneManager.removeScene(this);
		this.sceneManager = null;
	}
}
