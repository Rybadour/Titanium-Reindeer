import titanium_reindeer.core.IdProvider;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IHasId;

class IdProviderTests extends haxe.unit.TestCase
{
	private var provider:IdProvider;

	private var a:HasId;
	private var b:HasId;
	private var c:HasId;

	public override function setup()
	{
		this.provider = new IdProvider();

		this.a = new HasId();
		this.b = new HasId();
		this.c = new HasId();
	}

	public function test()
	{
		a.setupId(this.provider);
		b.setupId(this.provider);
		assertTrue(a.id != b.id);

		this.provider.freeUpId(b);
		c.setupId(this.provider);
		b.setupId(this.provider);
		assertTrue(a.id != b.id);
		assertTrue(a.id != c.id);
		assertTrue(b.id != c.id);
	}

	public override function tearDown()
	{
	}
}
