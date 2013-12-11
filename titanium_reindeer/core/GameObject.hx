package titanium_reindeer.core;

class GameObject implements IHasId
{
	public var id(default, null):Int;

	public function new(provider:IProvidesIds)
	{
		this.id = provider.getNextId();
	}
}
