package titanium_reindeer.core;

class Scene 
	implements IGroup<IHasUpdaterAndId>,
	implements IHasIdProvider,
	implements IHasUpdaterAndId
{
	public var idProvider(default, null):IdProvider;
	public var updater(default, null):Updater;

	public var id(default, null):Int;
	public var name(default, null):String;

	private var hasProvider:IHasIdProvider;
	private var objects:IntHash<IHasUpdaterAndId>;

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
	public function get(id:Int):IHasUpdaterAndId
	{
		if ( !this.objects.exists(id) )
			return null;

		return this.objects.get(id);
	}
	public function add(object:IHasUpdaterAndId):Void
	{
		this.objects.set(object.id, object);
	}
	public function remove(object:IHasUpdaterAndId):Void
	{
		if ( !this.objects.exists(object.id) )
			return;

		this.objects.remove(object.id);
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
