package titanium_reindeer.rendering;

import titanium_reindeer.core.Scene;

class RenderingScene extends Scene
{
	public var canvas(default, null):Canvas2D;

	public var width(get, null):Int;
	function get_width():Int { return this.canvas.width; }
	public var height(get, null):Int;
	function get_height():Int { return this.canvas.height; }

	public function new(width:Int, height:Int)
	{
		super();

		this.canvas = new Canvas2D("", width, height);
	}

	private override function postUpdate(msTimeStep:Int):Void
	{
		super.postUpdate(msTimeStep);

		this._render(this.canvas);
	}
	
	private function _render(canvas:Canvas2D):Void
	{
	}

	// TODO: Revise later, maybe call _render here
	public function render(canvas:Canvas2D):Void
	{
		canvas.renderCanvas(this.canvas);
	}
}
