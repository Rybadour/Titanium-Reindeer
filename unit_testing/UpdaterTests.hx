class UpdaterTests extends haxe.unit.TestCase
{
	private var hasProvider:HasIdProvider;

	private var inc:Incrementor;

	public override function setup()
	{
		this.hasProvider = new HasIdProvider();

		this.inc = new Incrementor(this.hasProvider);
	}

	public function tests()
	{
		assertEquals(this.inc.value, 0);

		this.inc.updater.preUpdate(1);
		this.inc.updater.update(1);
		assertEquals(this.inc.value, 1);

		this.inc.updater.postUpdate(1);
		this.inc.updater.pause();
		this.inc.updater.preUpdate(1);
		this.inc.updater.update(1);
		assertEquals(this.inc.value, 1);

		this.inc.updater.preUpdate(1);
		this.inc.updater.unpause();
		this.inc.updater.update(1);
		assertEquals(this.inc.value, 1);

		this.inc.updater.preUpdate(1);
		this.inc.updater.update(1);
		assertEquals(this.inc.value, 2);

		this.inc.updater.preUpdate(1);
		this.inc.updater.update(1);
		assertEquals(this.inc.value, 4);

		this.inc.updater.postUpdate(1);
		this.inc.updater.update(1);
		assertEquals(this.inc.value, 4);
	}

	public override function tearDown()
	{
	}
}
