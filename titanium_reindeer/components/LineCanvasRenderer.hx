package titanium_reindeer.components;

import titanium_reindeer.core.Relation;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.IRegion;
import titanium_reindeer.core.RectRegion;

class LineCanvasRenderer implements ICanvasRenderer
{
	public var id(default, null):Int;
	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.strokeFillState; }
	public var strokeFillState(default, null):CanvasStrokeFillState;

	private var relatedBounds:Relation2<Vector2, Vector2, RectRegion>;
	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion
	{
		return this.relatedBounds.value;
	}

	public var endPoint(default, null):Watcher<Vector2>;

	public function new(provider:IHasIdProvider, endPoint:Vector2)
	{
		this.id = provider.idProvider.requestId();
		this.strokeFillState = new CanvasStrokeFillState(this.render);

		this.endPoint = new Watcher(endPoint);

		this.relatedBounds = new Relation2(this.state.watchedPosition, this.endPoint, getBounds);
	}

	private function getBounds(position:Vector2, endPoint:Vector2):RectRegion
	{
		var topLeft:Vector2;
		if (endPoint.x < 0)
			 topLeft = position.add(endPoint);
		else
			topLeft = position.getCopy();
		var width:Float = Math.abs(endPoint.x);
		var height:Float = Math.abs(endPoint.y);

		return new RectRegion(width, height, topLeft.subtract(new Vector2(width, height)));
	}

	private function render(canvas:Canvas2D):Void
	{
		var lineWidth:Float = this.strokeFillState.lineWidth;
		if (lineWidth > 0)
		{
			canvas.ctx.beginPath();
			canvas.ctx.moveTo(0, 0);
			canvas.ctx.lineTo(this.endPoint.value.x, this.endPoint.value.y);
			canvas.ctx.stroke();
			canvas.ctx.closePath();
		}
	}
}
