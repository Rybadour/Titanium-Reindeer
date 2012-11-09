import titanium_reindeer.components.ImageCanvasRenderer;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.ImageSource;

class Guy
{
	public var scene(default, null):RenderScene;
    public var body:ImageCanvasRenderer;

    public function new(scene:RenderScene, layerName:String)
    {
		this.scene = scene;

		var image:ImageSource = new ImageSource("img/guy.jpg");
		this.body = new ImageCanvasRenderer(scene, image);
		this.scene.addRenderer(this.body.id, this.body, layerName);
    }
}
