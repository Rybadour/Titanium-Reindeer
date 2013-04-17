package titanium_reindeer;

class MovementComponentManager extends ComponentManager
{
	override public function update(msTimeStep:Int):Void
	{
		for (component in components)
		{
			if (Std.is(component, MovementComponent) && component.enabled && component.owner != null)
				cast(component, MovementComponent).move(msTimeStep);
		}
	}
}
