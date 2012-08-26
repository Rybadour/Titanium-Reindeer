import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IHasUpdaterAndId;
import titanium_reindeer.core.Updater;

class Incrementor implements IHasUpdaterAndId
{
	public var id(default, null):Int;
	public var updater(default, null):Updater;

	private var valueInc:Int;
	public var value(default, null):Int;

	public function new(provider:IHasIdProvider)
	{
		this.id = provider.idProvider.requestId();
		this.updater = new Updater(preUpdate, update, postUpdate);

		this.value = 0;
		this.valueInc = 0;
	}

	private function preUpdate(msTimeStep:Int):Void
	{
		this.valueInc += msTimeStep;
	}

	private function update(msTimeStep:Int):Void
	{
		this.value += this.valueInc;
	}

	private function postUpdate(msTimeStep:Int):Void
	{
		this.valueInc = 0;
	}
}
