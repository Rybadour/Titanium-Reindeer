package titanium_reindeer.components;

class RectCanvasRenderer implements ICanvasRenderer
{
	public var id(default, null):Int;
	public var state(default, null):CanvasStrokeFillState;

	public var shape(getShape, null):IShape;
	public function getShape():IShape
	{
		return this.relatedRect.value;
	}

	private var relatedRect:Relation2<Float, Float, Rect>;
	
	public var width:Watcher<Float>;
	public var height:Watcher<Float>;

	public function new(idProvider:IHasIdProvider, width:Float, height:Float)
	{
		this.id = idProvider.requestId();
		this.state = new CanvasStrokeFillState(this.render);

		this.width = new Watcher(width);
		this.height = new Watcher(height);
		this.relatedRect = new Relation2(this.width, this.height, getBounds);
	}

	private function getBounds(width:Float, height:Float):Rect
	{
		return new Rect(0, 0, width, height);
	}

	private function render(canvas:Canvas2D):Void
	{
		var x:Float = -width/2;
		var y:Float = -height/2;

		canvas.ctx.fillRect( x, y, width, height );

		if (lineWidth > 0)
		{
			canvas.ctx.strokeRect(
				x + lineWidth/2,
				y + lineWidth/2,
				width - lineWidth, 
				height - lineWidth
			);
		}
	}
}
