import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IdProvider;

class Provider implements IHasIdProvider
{
	public var idProvider(default, null):IdProvider;

	public function new()
	{
		this.idProvider = new IdProvider();
	}
}
