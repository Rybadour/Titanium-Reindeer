package titanium_reindeer;

class LineRenderer extends StrokeFillRenderer
{
	private var watchedEndPoint:WatchedVector2;
	public var endPoint(getEndPoint, setEndPoint):Vector2;
	private function getEndPoint():Vector2
	{
		return watchedEndPoint;
	}
	private function setEndPoint(value:Vector2):Vector2
	{
		if (value != null)
		{
			if ( watchedEndPoint != value && !watchedEndPoint.equal(value) )
			{
				watchedEndPoint.setVector2(value);
			}
		}

		return endPoint;
	}

	private var startPointAlignment:Vector2;
	private var requestedOffset:Vector2;
	override private function setOffset(value:Vector2):Vector2
	{
		if (value != null && value != this.offset)
		{
			this.requestedOffset = value.getCopy();
			value.addTo(this.startPointAlignment);
		}

		return super.setOffset(value);
	}

	override private function offsetChanged():Void
	{
		// Either the x or y of the offset changed, figure out which one
		var oldRequestedOffset:Vector2 = this.offset.subtract(this.startPointAlignment);
		if (this.requestedOffset.x == oldRequestedOffset.x)
		{
			this.setOffset(new Vector2(this.requestedOffset.x, oldRequestedOffset.y));
		}
		else
		{
			this.setOffset(new Vector2(oldRequestedOffset.x, this.requestedOffset.y));
		}
	}

	override private function setLineWidth(value:Int):Int
	{
		var result = super.setLineWidth(value);
		
		this.recalculateDrawnSize();

		return result;
	}

	public function new(endPoint:Vector2, layer:Int)
	{
		super(0, 0, layer);
		this.startPointAlignment = new Vector2(0, 0);
		this.requestedOffset = new Vector2(0, 0);
		this.watchedEndPoint = new WatchedVector2(endPoint.x, endPoint.y, endPointChanged);

		this.recalculateAlignment();
		this.recalculateDrawnSize();
		this.lineWidth = 1;
	}

	private function endPointChanged():Void
	{
		this.recalculateAlignment();
		this.recalculateDrawnSize();
	}

	private function recalculateAlignment():Void
	{
		if (this.endPoint == null)
			return;

		// Find the new alignment and offset
		this.startPointAlignment = this.endPoint.getExtend(0.5);
		this.offset = this.requestedOffset;
	}

	private function recalculateDrawnSize():Void
	{
		var width:Float = 0;
		var height:Float = 0;
		if (this.endPoint != null)
		{
			width = Math.abs(this.endPoint.x);
			height = Math.abs(this.endPoint.y);
		}

		this.initialDrawnWidth = width + this.lineWidth + 2;
		this.initialDrawnHeight = height + this.lineWidth + 2;
	}

	override public function render():Void
	{
		super.render();

		if (this.lineWidth > 0)
		{
			var start:Vector2 = this.startPointAlignment.getReverse();
			var end:Vector2 = start.add(this.endPoint);

			pen.beginPath();
			pen.moveTo(start.x, start.y);
			pen.lineTo(end.x, end.y);
			pen.stroke();
			pen.closePath();
		}
	}
}
