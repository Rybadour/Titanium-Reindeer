import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IdProvider;
import titanium_reindeer.core.IHasId;
import titanium_reindeer.core.IHasUpdater;
import titanium_reindeer.core.SceneBase;
import titanium_reindeer.components.IWatchedWorldPosition;

import titanium_reindeer.Vector2;
import titanium_reindeer.Rect;
import titanium_reindeer.Circle;

class SceneBaseTests extends haxe.unit.TestCase
{
	private var idProvider:HasIdProvider;
	private var sceneBase:SceneBase;

	public override function setup()
	{
		this.idProvider = new HasIdProvider();
		this.sceneBase = new SceneBase(this.idProvider, "testScene");
	}

	public function testInitialization()
	{
		assertTrue(this.sceneBase.idProvider != null);
	}

	public function testUpdater()
	{
		var a:Incrementor = new Incrementor(this.idProvider);
		var b:Incrementor = new Incrementor(this.idProvider);
		this.sceneBase.add(a);

		assertEquals(a.value, 0);

		// update and propagation
		this.sceneBase.updater.preUpdate(1);
		a.updater.update(1);
		assertEquals(a.value, 1);

		// pausing
		this.sceneBase.add(b);

		this.sceneBase.updater.pause();
		this.sceneBase.updater.preUpdate(1);
		this.sceneBase.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 0);
		this.sceneBase.updater.postUpdate(1);

		this.sceneBase.updater.unpause();

		a.updater.pause();
		this.sceneBase.updater.preUpdate(1);
		this.sceneBase.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 1);
		this.sceneBase.updater.postUpdate(1);

		this.sceneBase.updater.pause();
		this.sceneBase.updater.preUpdate(1);
		this.sceneBase.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 1);
		this.sceneBase.updater.postUpdate(1);

		this.sceneBase.updater.unpause();
		this.sceneBase.updater.preUpdate(1);
		this.sceneBase.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 2);
		this.sceneBase.updater.postUpdate(1);

		a.updater.unpause();
		this.sceneBase.updater.postUpdate(1);

		this.sceneBase.updater.preUpdate(1);
		this.sceneBase.updater.update(1);
		assertEquals(a.value, 2);
		assertEquals(b.value, 3);
		this.sceneBase.updater.postUpdate(1);

		// removal
	}

	public override function tearDown()
	{
	}
}
