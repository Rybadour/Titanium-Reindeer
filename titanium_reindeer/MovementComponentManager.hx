package titanium_reindeer;

class MovementComponentManager extends ComponentManager
{
	override public function update(msTimeStep:Int):Void
	{
		for (component in components)
		{
			if (cast(component, MovementComponent) != null && component.enabled)
				cast(component, MovementComponent).move(msTimeStep);
		}
	}
}
