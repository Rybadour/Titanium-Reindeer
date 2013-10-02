package titanium_reindeer.rendering;

import titanium_reindeer.spatial.Rect;
import titanium_reindeer.spatial.RectRegion;

class RectRenderer extends Renderer<StrokeFillState>
{
	public var rect(default, null):Rect;

	public function new(rect:Rect)
	{
		super(new StrokeFillState());

		this.rect = rect;
	}

	private override function _render(canvas:Canvas2D):Void
	{
		canvas.renderRect(this.rect);
	}
}
