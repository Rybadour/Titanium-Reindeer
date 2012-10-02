package titanium_reindeer.components;

import titanium_reindeer.core.Relation;
import titanium_reindeer.core.Watcher;
import titanium_reindeer.core.IHasIdProvider;
import titanium_reindeer.core.IShape;

class RectCanvasRenderer implements ICanvasRenderer
{
	public var id(default, null):Int;
	public var state(getState, null):CanvasRenderState;
	public function getState():CanvasRenderState { return this.strokeFillState; }
	public var strokeFillState(default, null):CanvasStrokeFillState;

	public var boundingShape(getBoundingShape, null):IShape;
	public function getBoundingShape():IShape
	{
		return this.relatedRect.value;
	}

	private var relatedRect:Relation2<Float, Float, Rect>;
	
	public var width:Watcher<Float>;
	public var height:Watcher<Float>;

	public function new(provider:IHasIdProvider, width:Float, height:Float)
	{
		this.id = provider.idProvider.requestId();
		this.strokeFillState = new CanvasStrokeFillState(this.render);

		this.width = new Watcher(width);
		this.height = new Watcher(height);
		this.relatedRect = new Relation2(this.width, this.height, getBounds);
	}

	private function getBounds(width:Float, height:Float):Rect
	{
		return new Rect(width, height);
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
