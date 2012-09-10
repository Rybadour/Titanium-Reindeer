package titanium_reindeer;

import titanium_reindeer.core.IHasIdProvider;

class StandardScene extends Scene
{
	private var collisionReporters:Scene;

	public function new(provider:IHasIdProvider, name:String)
	{
		super(provider, name);

		this.collisionReporters = new Scene(provider, "collisionReporters");

		// Add our groups in this order to control when each type of thing is updated
		this.add(this.collisionReporters);
	}

	public override function add(obj:IHasUpdaterAndId):Void
	{
		if ( Std.is(obj, CollisionReporter) )
			this.collisionReporters.add(obj);
		else
			super.add(obj);
	}

	public override function remove(obj:IHasUpdaterAndId):Void
	{
		if ( Std.is(obj, CollisionReporter) )
			this.collisionReporters.remove(obj);
		else
			super.add(obj);
	}
}
