class HasUpdater implements IHasUpdater
{
	public var updater(default, null):Updater;

	public function new()
	{
		this.updater = new Updater(null, null, null);
	}
}
