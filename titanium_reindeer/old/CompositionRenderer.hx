package titanium_reindeer;

class CompositionRenderer extends RendererComponent
{
	private var compositionCanvas:Dynamic;
	private var compositionPen:Dynamic;

	private var layers:Array<CompositionLayer>;

	private var maxWidth:Float;
	private var maxHeight:Float;

	public function new(layers:Array<CompositionLayer>, layerNum:Int)
	{
		this.layers = layers;
		this.maxWidth = 0;
		this.maxHeight = 0;
		for (layer in this.layers)
		{
			if (layer.renderer.drawnWidth > this.maxWidth)
				this.maxWidth = layer.renderer.drawnWidth;

			if (layer.renderer.drawnHeight > this.maxHeight)
				this.maxHeight = layer.renderer.drawnHeight;
		}

		super(this.maxWidth, this.maxHeight, layerNum);

		this.compositionCanvas = js.Lib.document.createElement("canvas");
		this.compositionCanvas.setAttribute("width", (this.maxWidth+2)+"px");
		this.compositionCanvas.setAttribute("height", (this.maxHeight+2)+"px");
		this.compositionPen = this.compositionCanvas.getContext("2d");
	}

	override public function initialize():Void
	{
		super.initialize();
	}

	override public function preRender():Void
	{
		super.preRender();

		for (layer in this.layers)
		{
			layer.renderer.useAlternateCanvas(this.compositionPen, new Vector2(this.maxWidth/2 + 1, this.maxHeight/2 + 1));
		}
	}

	override public function render():Void
	{
		super.render();

		for (layer in this.layers)
		{
			// set the composition based on the layer but after the preRender
			layer.renderer.preRender();
			this.compositionPen.globalCompositeOperation = RendererComponent.CompositionToString(layer.renderComposition);

			layer.renderer.render();
			layer.renderer.postRender();
		}

		// Finally take out composition of renderers and blend it to the canvas
		this.pen.drawImage(this.compositionCanvas, -this.maxWidth/2 - 1, -this.maxHeight/2 - 1);
	}

	override public function postRender():Void
	{
		for (layer in this.layers)
		{
			layer.renderer.disableAlternateCanvas();
		}

		super.postRender();
	}
}
