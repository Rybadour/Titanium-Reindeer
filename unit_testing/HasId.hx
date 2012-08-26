import titanium_reindeer.core.IdProvider;
import titanium_reindeer.core.IHasId;

class HasId implements IHasId
{
	public var id(default, null):Int;

	public function new()
	{
	}

	public function setupId(idProvider:IdProvider)
	{
		this.id = idProvider.requestId();
	}
}
