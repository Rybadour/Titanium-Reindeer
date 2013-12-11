package titanium_reindeer.rendering;

import titanium_reindeer.assets.ILoadable;

class ProgressBarRenderer extends Renderer<RenderState>
{
	public var asset(default, null):ILoadable;

	public var bgState(default, null):StrokeFillState;
	public var fgState(default, null):StrokeFillState;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var fgMargin(default, null):Int;

	public function new(asset:ILoadable, width:Int, height:Int)
	{
		super(new StrokeFillState());

		this.asset = asset;

		this.bgState = new StrokeFillState();
		this.bgState.strokeColor = Color.Black;
		this.bgState.fillColor = Color.White;
		this.bgState.lineWidth = 2;

		this.fgState = new StrokeFillState();
		this.fgState.fillColor = Color.Red;

		this.width = width;
		this.height = height;
		this.fgMargin = 3;
	}

	// TODO: Probably just abstract the two calls to renderRectf so this idea can be styled any which way
	// TODO: Modifying the state of this class does not affect renderering
	//       It is overridden by the inner states
	private override function _render(canvas:Canvas2D):Void
	{
		canvas.save();
		this.bgState.apply(canvas);
		canvas.renderRectf(width, height);
		canvas.restore();

		var progress = Utility.clampFloat(this.asset.getProgress(), 0, 1);

		canvas.save();
		this.fgState.apply(canvas);
		canvas.translatef(this.fgMargin, this.fgMargin);
		canvas.renderRectf(progress*(width - fgMargin*2), height - fgMargin*2);
		canvas.restore();
	}
}
