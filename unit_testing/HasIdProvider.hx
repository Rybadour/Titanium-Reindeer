import titanium_reindeer.core.IdProvider;
import titanium_reindeer.core.IHasIdProvider;

class HasIdProvider implements IHasIdProvider
{
	public var idProvider(default, null):IdProvider;

	public function new()
	{
		this.idProvider = new IdProvider();
	}
}
