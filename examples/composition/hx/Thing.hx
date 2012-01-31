import titanium_reindeer.GameObject;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.CompositionRenderer;
import titanium_reindeer.CompositionLayer;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.Enums;
import titanium_reindeer.Color;
import titanium_reindeer.Vector2;

class Thing extends GameObject
{
    public var body:CompositionRenderer;
    public var velo:MovementComponent;

    public function new()
    {
        super();

		var a:CircleRenderer = new CircleRenderer(40, Layers.ALPHA);
		a.fillColor = Color.White;
		var b:CirclePortion = new CirclePortion(40, Math.PI, Math.PI*3/2, Layers.ALPHA);

        this.body = new CompositionRenderer([
            new CompositionLayer(a),
            new CompositionLayer(b, Composition.DestinationOut)
        ],
        Layers.BETA);
        this.addComponent("body", this.body);

        this.velo = new MovementComponent(new Vector2(0, 8));
        this.addComponent("velo", this.velo);
    }
}
