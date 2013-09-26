package titanium_reindeer;

class MovementComponent extends Component
{
	public var velocity(default, setVelocity):Vector2;
	private function setVelocity(value:Vector2):Vector2
	{
		if (value != null && !value.equal(this.velocity))
		{
			this.velocity = value.getCopy();
		}

		return this.velocity;
	}
	
	public function new(?velocity:Vector2)	
	{
		super();

		this.velocity = velocity == null ? new Vector2(0, 0) : velocity;
	}

	public function move(msTimeStep:Int):Void
	{
		// Apply the velocity to the game object at a per second rate
		owner.position.addTo( this.velocity.getExtend(msTimeStep/1000) );
	}

	override public function getManagerType():Class<ComponentManager>
	{
		return MovementComponentManager;
	}

	override public function destroy():Void
	{
		super.destroy();
		velocity = null;
	}
}
