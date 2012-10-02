package titanium_reindeer.components;

import titanium_reindeer.core.Relation;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IShape;
import titanium_reindeer.core.IRegion;
import titanium_reindeer.core.RectRegion;

class RectCanvasRenderer implements ICanvasRenderer
{
	public var id(default, null):Int;
	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.strokeFillState; }
	public var strokeFillState(default, null):CanvasStrokeFillState;

	private var relatedRect:Relation3<Float, Float, Vector2, RectRegion>;
	public var boundingRegion(getBoundingRegion, never):IRegion;
	public function getBoundingRegion():IRegion
	{
		return this.relatedRect.value;
	}

	public var width(default, null):Watcher<Float>;
	public var height(default, null):Watcher<Float>;

	public function new(provider:IHasIdProvider, width:Float, height:Float)
	{
		this.id = provider.idProvider.requestId();
		this.strokeFillState = new CanvasStrokeFillState(this.render);

		this.width = new Watcher(width);
		this.height = new Watcher(height);

		this.relatedRect = new Relation3(this.width, this.height, this.state.watchedPosition, getBounds);
	}

	private function getBounds(width:Float, height:Float, position:Vector2):RectRegion
	{
		return new RectRegion(width, height, position);
	}

	private function render(canvas:Canvas2D):Void
	{
		var x:Float = -this.width.value/2;
		var y:Float = -this.height.value/2;

		canvas.ctx.fillRect( x, y, this.width.value, this.height.value );

		var lineWidth:Float = this.strokeFillState.lineWidth;
		if (lineWidth > 0)
		{
			canvas.ctx.strokeRect(
				x + lineWidth/2,
				y + lineWidth/2,
				this.width.value - lineWidth, 
				this.height.value - lineWidth
			);
		}
	}
}
