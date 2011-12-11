import titanium_reindeer.Color;
import titanium_reindeer.Vector2;
import titanium_reindeer.CircleRenderer;
import titanium_reindeer.RendererComponent;

class WobbleBall extends MovableObject
{
	public var wobbleRadius:Float;
	public var wobbleRate:Float;
	private var wobbleAngle:Float;

	public function new(radius:Float, layer:Int, color:Color, wobbleRadius:Float)
	{
		super(new Vector2(0, 0));

		if (wobbleRadius == null)
			this.wobbleRadius = 50;
		else
			this.wobbleRadius = wobbleRadius;
		this.wobbleRate = 0.1;
		this.wobbleAngle = 0;

		var circ:CircleRenderer = new CircleRenderer(radius, layer);
		circ.alpha = 1;
		circ.fillColor = color;
		circ.borderWidth = 2;
		circ.borderColor = new Color(255 - color.red, 255 - color.green, 255 - color.blue, color.alpha);
		super.addComponent("mainCircle", circ);
	}

	override public function update():Void
	{
		cast(this.getComponent("mainCircle"), RendererComponent).offset = new Vector2(1, 0);
		cast(this.getComponent("mainCircle"), RendererComponent).offset.rotate(wobbleAngle);
		cast(this.getComponent("mainCircle"), RendererComponent).offset.extend(wobbleRadius);
		
		wobbleAngle += wobbleRate;
		wobbleAngle %= Math.PI*2;
	}
}
