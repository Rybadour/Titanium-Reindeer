import titanium_reindeer.Rect;
import titanium_reindeer.Color;
import titanium_reindeer.RectRenderer;

class RectIntersection extends RectObj
{
	private var rectA:RectObj;
	private var rectB:RectObj;

	public function new (a:RectObj, b:RectObj, color:Color)
	{
		super(new Rect(0, 0, 0, 0), color);

		rectA = a;
		rectB = b;
	}

	override public function update(msTimeStep:Int):Void
	{
		var middle:Rect = Rect.getIntersection(rectA.bounds, rectB.bounds);
	
		if (middle != null)
		{
			this.position.x = middle.x + middle.width/2;
			this.position.y = middle.y + middle.height/2;

			cast(this.getComponent("mainRect"), RectRenderer).width = middle.width;
			cast(this.getComponent("mainRect"), RectRenderer).height = middle.height;
		}
	}
}
