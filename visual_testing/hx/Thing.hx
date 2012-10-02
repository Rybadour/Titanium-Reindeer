import titanium_reindeer.components.RectCanvasRenderer;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class Thing
{
	public var scene(default, null):RenderScene;
    public var body:RectCanvasRenderer;

    public function new(scene:RenderScene)
    {
		this.scene = scene;

		this.body = new RectCanvasRenderer(scene, 40, 100);
		this.body.strokeFillState.fillColor = Color.Red;
		this.scene.addRenderer(this.body.id, this.body, "things");
    }
}
