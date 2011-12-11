import titanium_reindeer.GameObject;
import titanium_reindeer.Vector2;
import titanium_reindeer.MovementComponent;

class MovableObject extends GameObject
{
	public var velocity(getVelocity, setVelocity):Vector2;	
	public function getVelocity():Vector2
	{
		return cast(this.getComponent("velocity"), MovementComponent).velocity;
	}
	public function setVelocity(velocity:Vector2):Vector2
	{
		cast(this.getComponent("velocity"), MovementComponent).velocity = velocity;
		return velocity;
	}

	public function new(velocity:Vector2)
	{
		super();

		super.addComponent("velocity", new MovementComponent(velocity));
	}
}
