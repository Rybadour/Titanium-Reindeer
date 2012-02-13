package titanium_reindeer;

class RendererComponentManager extends ComponentManager
{
	public var renderLayerManager(default, null):RenderLayerManager;
	public var cachedBitmaps(default, null):CachedBitmaps; 

	public function new(scene:Scene)
	{
		super(scene);

		var game:Game = this.scene.game;

		this.renderLayerManager = new RenderLayerManager(scene, game.targetElement, game.width, game.height);

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

	public function getImageFromPath(path:String):ImageSource
	{
		// append a uniqueish phrase so that name clashes with renderer identify's are improbable
		var pathIdentifier:String = "filePath:" + path;

		if (this.cachedBitmaps.exists(pathIdentifier))
			return this.cachedBitmaps.get(pathIdentifier);

		var imageSource:ImageSource = new ImageSource(path);
		this.cachedBitmaps.set(pathIdentifier, imageSource);
		return imageSource;
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
