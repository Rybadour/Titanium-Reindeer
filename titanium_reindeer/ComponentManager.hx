package titanium_reindeer;

class ComponentManager extends ObjectManager
{
	public var scene(default, null):Scene;

	public var components(getComponents, null):Array<Component>;
	public function getComponents():Array<Component>
	{
		if (this.componentsChanged)
		{
			this.components = new Array();
			for (obj in objects)
			{
				this.components.push( cast(obj, Component) );	
			}

			this.componentsChanged = false;
		}

		return this.components;
	}
	
	private var componentsChanged:Bool;

	public function new(scene:Scene)
	{
		super();

		this.scene = scene;

		componentsChanged = true;
	}

	public function preUpdate(msTimeStep:Int):Void { }
	public function update(msTimeStep:Int):Void { }
	public function postUpdate(msTimeStep:Int):Void { }

	public function addComponent(component:Component):Void
	{
		super.addObject(component);

		componentsChanged = true;
	}

	public function removeComponent(component:Component):Void
	{
		super.removeObject(component);

		componentsChanged = true;
	}

	public function removeComponents():Void
	{
		super.removeObjects();

		componentsChanged = true;
	}

	override public function finalDestroy():Void
	{
		super.finalDestroy();

		this.components = null;

		this.scene = null;
	}
}
