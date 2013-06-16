import titanium_reindeer.components.LineCanvasRenderer;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.ImageSource;

class Line
{
	public var scene(default, null):RenderScene;
    public var body:LineCanvasRenderer;

    public function new(scene:RenderScene, endPoint:Vector2, layerName:String)
    {
		this.scene = scene;

		this.body = new LineCanvasRenderer(scene, endPoint);
		this.scene.addRenderer(this.body.id, this.body, layerName);
    }
}
