package titanium_reindeer;

class Component extends ManagedObject
{
	public var owner(default, null):GameObject;

	public var componentManager(getManager, null):ComponentManager;
	public function getManager():ComponentManager
	{
		if (this.manager == null)
			return null;
		else
			return cast(this.manager, ComponentManager);
	}

	public var enabled(default, setEnabled):Bool;
	public function setEnabled(value:Bool):Bool
	{
		this.enabled = value;

		return this.enabled;
	}

	// Constructor
	public function new()
	{
		super();

		this.enabled = true;
	}

	public function setOwner(gameObject:GameObject):Void
	{
		if (this.owner == null)
		{
			this.owner = gameObject;
		}
	}

	// Called when the manager of this component is set
	public function initialize():Void { }
	public function getManagerType():Class<ComponentManager>
	{
		return ComponentManager;
	}

	// Called when the owner changes position
	public function notifyPositionChange():Void { }

	// Internal Only
	override public function remove():Void
	{
		super.remove();

		this.owner = null;

		if (this.componentManager != null)
			this.componentManager.removeComponent(this);
	}

	override public function destroy():Void
	{
		this.remove();
		this.enabled = false;

		super.destroy();
	}

	override public function finalDestroy():Void
	{
		super.finalDestroy();

		this.owner = null;
		this.componentManager = null;
		this.enabled = false;
	}
}
