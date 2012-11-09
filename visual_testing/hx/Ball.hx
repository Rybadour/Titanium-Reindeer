import titanium_reindeer.components.CircleCanvasRenderer;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class Ball
{
	public var scene(default, null):RenderScene;
    public var body:CircleCanvasRenderer;

    public function new(scene:RenderScene, color:Color, radius:Float, layerName:String)
    {
		this.scene = scene;

		this.body = new CircleCanvasRenderer(scene, radius);
		this.body.strokeFillState.fillColor = color;
		this.scene.addRenderer(this.body.id, this.body, layerName);
    }
}
