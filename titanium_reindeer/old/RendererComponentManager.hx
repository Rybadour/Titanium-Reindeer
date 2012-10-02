package titanium_reindeer;

class RendererComponentManager extends ComponentManager
{
	public var renderLayerManager(default, null):RenderLayerManager;

	public var bitmapCache(getBitmapCache, null):BitmapCache;
	public function getBitmapCache():BitmapCache
	{
		return this.scene.bitmapCache;
	}

	public function new(scene:Scene)
	{
		super(scene);

		var game:Game = this.scene.game;

		this.renderLayerManager = new RenderLayerManager(scene, game.targetElement, game.width, game.height);
	}

	override public function postUpdate(msTimeStep:Int):Void
	{
		// Rendering
		renderLayerManager.clear();

		for (component in components)
		{
			var renderer:RendererComponent = cast(component, RendererComponent);
			
			renderer.update(msTimeStep);

			if (renderer.layer != null && renderer.visible && (renderer.timeForRedraw || renderer.layer.redrawBackground))
			{
				renderer.preRender();
				if (renderer.usingSharedBitmap)
					renderer.renderSharedBitmap();
				else
					renderer.render();
				renderer.postRender();
			}

			renderer.setLastRendered();
		}

		// Displays the contents stored in the buffers
		renderLayerManager.display();
	}

	override public function finalDestroy():Void
	{
		// destroy my children
		super.finalDestroy();

		renderLayerManager.destroy();
		renderLayerManager = null;
	}
}
