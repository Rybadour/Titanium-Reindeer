package titanium_reindeer.components;

import titanium_reindeer.core.Relation;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.IRegion;

class CircleRenderer extends CanvasRenderer
{
	public var circle(default, null):Circle;

	public function new(circle:Circle)
	{
		super(new CanvasStrokeFillState());

		this.circle = circle;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		canvas.renderCircle(this.circle);

		/* *
		var lineWidth:Float = this.strokeFillState.lineWidth;
		if (lineWidth > 0)
		{
			canvas.ctx.beginPath();
			canvas.ctx.arc(0, 0, this.radius.value - lineWidth/2, 0, Math.PI*2, false);
			canvas.ctx.stroke();
			canvas.ctx.closePath();
		}
		/* */
	}
}
