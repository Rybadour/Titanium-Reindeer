package titanium_reindeer.components;

import titanium_reindeer.core.Relation;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.IRegion;

class CircleCanvasRenderer implements ICanvasRenderer
{
	public var id(default, null):Int;
	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.strokeFillState; }
	public var strokeFillState(default, null):CanvasStrokeFillState;

	private var relatedCircle:Relation2<Float, Vector2, CircleRegion>;
	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion
	{
		return this.relatedCircle.value;
	}

	public var radius(default, null):Watcher<Float>;

	public function new(provider:IHasIdProvider, radius:Float)
	{
		this.id = provider.idProvider.requestId();
		this.strokeFillState = new CanvasStrokeFillState(this.render);

		this.radius = new Watcher(radius);

		this.relatedCircle = new Relation2(this.radius, this.state.watchedPosition, getBounds);
	}

	private function getBounds(radius:Float, position:Vector2):CircleRegion
	{
		return new CircleRegion(radius, position);
	}

	private function render(canvas:Canvas2D):Void
	{
		canvas.ctx.beginPath();
		canvas.ctx.arc(0, 0, this.radius.value, 0, 2*Math.PI, false);
		canvas.ctx.fill();
		canvas.ctx.closePath();

		var lineWidth:Float = this.strokeFillState.lineWidth;
		if (lineWidth > 0)
		{
			canvas.ctx.beginPath();
			canvas.ctx.arc(0, 0, this.radius.value - lineWidth/2, 0, Math.PI*2, false);
			canvas.ctx.stroke();
			canvas.ctx.closePath();
		}
	}
}
