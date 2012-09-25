package titanium_reindeer.core;

class Scene 
	implements IGroup<IHasUpdater>,
	implements IHasIdProvider,
	implements IHasUpdater,
	implements IHasId
{
	public var idProvider(default, null):IdProvider;
	public var updater(default, null):Updater;

	public var id(default, null):Int;
	public var name(default, null):String;

	private var hasProvider:IHasIdProvider;
	private var objects:IntHash<IHasUpdater>;

	public function new(provider:IHasIdProvider, name:String)
	{
		this.hasProvider = provider;
		this.id = this.hasProvider.idProvider.requestId();

		this.name = name;
		this.idProvider = new IdProvider();
		this.updater = new Updater(preUpdate, update, postUpdate);

		this.objects = new IntHash();
	}

	// As a Group
	public function get(id:Int):IHasUpdater
	{
		if ( !this.objects.exists(id) )
			return null;

		return this.objects.get(id);
	}
	public function add(id:Int, object:IHasUpdater):Void
	{
		this.objects.set(id, object);
	}
	public function remove(id:Int):Void
	{
		if ( !this.objects.exists(id) )
			return;

		this.objects.remove(id);
	}

	// Real-time updates
	private function preUpdate(msTimeStep:Int):Void
	{
		for (obj in objects)
			obj.updater.preUpdate(msTimeStep);
	}
	private function update(msTimeStep:Int):Void
	{
		for (obj in objects)
			obj.updater.update(msTimeStep);
	}
	private function postUpdate(msTimeStep:Int):Void
	{
		for (obj in objects)
			obj.updater.postUpdate(msTimeStep);
	}
}
