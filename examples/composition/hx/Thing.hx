import titanium_reindeer.GameObject;
import titanium_reindeer.MovementComponent;
import titanium_reindeer.CompositionRenderer;
import titanium_reindeer.CompositionLayer;
import titanium_reindeer.RectRenderer;
import titanium_reindeer.CircleRenderer;

class Thing extends GameObject
{
    public var body:CompositionRenderer;
    public var velo:MovementComponent;

    public function new()
    {
        super();

        this.body = new CompositionRenderer([
            new CompositionLayer(new RectRenderer(40, 40, Layers.ALPHA)),
            new CompositionLayer(new CircleRenderer(20, 20, Layers.ALPHA), Composition.DestinationOut)
        ],
        Layers.BETA);
        this.addComponent("body", this.body);

        this.velo = new MovementComponent(new Vector2(5, 0));
        this.addComponent("velo", this.velo);
    }
}
