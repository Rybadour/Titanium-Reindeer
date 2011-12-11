package titanium_reindeer;

class RendererComponentManager extends ComponentManager
{
	public var renderLayerManager(default, null):RenderLayerManager;
	public var cachedBitmaps(default, null):CachedBitmaps; 

	public function new(gameObjectManager:GameObjectManager)
	{
		super(gameObjectManager);

		var game:Game = this.gameObjectManager.game;

		this.renderLayerManager = new RenderLayerManager(game.layerCount, game.targetElement, game.backgroundColor, game.width, game.height);

		this.cachedBitmaps = new CachedBitmaps();
	}

	override public function postUpdate(msTimeStep:Int):Void
	{
		// Rendering
		renderLayerManager.clear();

		for (component in components)
		{
			var renderer:RendererComponent = cast(component, RendererComponent);
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

	override public function destroy():Void
	{
		// destroy my children
		super.destroy();

		renderLayerManager.destroy();
		renderLayerManager = null;

		cachedBitmaps.destroy();
		cachedBitmaps = null;
	}
}
