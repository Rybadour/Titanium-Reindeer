import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IdProvider;
import titanium_reindeer.core.IHasId;
import titanium_reindeer.core.IHasUpdater;
import titanium_reindeer.core.Scene;
import titanium_reindeer.components.IWatchedWorldPosition;

import titanium_reindeer.Vector2;
import titanium_reindeer.Rect;
import titanium_reindeer.Circle;

class SceneTests extends haxe.unit.TestCase
{
	private var idProvider:HasIdProvider;
	private var scene:Scene;

	public override function setup()
	{
		this.idProvider = new HasIdProvider();
		this.scene = new Scene(this.idProvider, "testScene");
	}

	public function testInitialization()
	{
		assertTrue(this.scene.idProvider != null);
	}

	public function testUpdater()
	{
		var a:Incrementor = new Incrementor(this.idProvider);
		var b:Incrementor = new Incrementor(this.idProvider);
		this.scene.add(a.id, a);

		assertEquals(a.value, 0);

		// update and propagation
		this.scene.updater.preUpdate(1);
		a.updater.update(1);
		assertEquals(a.value, 1);

		// pausing
		this.scene.add(b.id, b);

		this.scene.updater.pause();
		this.scene.updater.preUpdate(1);
		this.scene.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 0);
		this.scene.updater.postUpdate(1);

		this.scene.updater.unpause();

		a.updater.pause();
		this.scene.updater.preUpdate(1);
		this.scene.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 1);
		this.scene.updater.postUpdate(1);

		this.scene.updater.pause();
		this.scene.updater.preUpdate(1);
		this.scene.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 1);
		this.scene.updater.postUpdate(1);

		this.scene.updater.unpause();
		this.scene.updater.preUpdate(1);
		this.scene.updater.update(1);
		assertEquals(a.value, 1);
		assertEquals(b.value, 2);
		this.scene.updater.postUpdate(1);

		a.updater.unpause();
		this.scene.updater.postUpdate(1);

		this.scene.updater.preUpdate(1);
		this.scene.updater.update(1);
		assertEquals(a.value, 2);
		assertEquals(b.value, 3);
		this.scene.updater.postUpdate(1);

		// removal
	}

	public override function tearDown()
	{
	}
}
