import titanium_reindeer.components.RectCanvasRenderer;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class Thing
{
	public var scene(default, null):RenderScene;
    public var body:RectCanvasRenderer;

    public function new(scene:RenderScene, color:Color, width:Float, layerName:String)
    {
		this.scene = scene;

		this.body = new RectCanvasRenderer(scene, width, 200);
		this.body.strokeFillState.fillColor = color;
		this.scene.addRenderer(this.body.id, this.body, layerName);
    }
}
