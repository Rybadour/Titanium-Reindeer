package titanium_reindeer;

import js.Dom;

class RenderLayerManager
{
	private var layers:Array<RenderLayer>;
	
	private var gameWidth:Int;
	private var gameHeight:Int;

	private var canvas:Dynamic;
	private var pen:Dynamic;
	private var visiblePen:Dynamic;

	// Constructor
	public function new(numLayers:Int, targetElement:HtmlDom, backgroundColor:Color,
						gameWidth:Int, gameHeight:Int)
	{
		this.gameWidth = gameWidth;
		this.gameHeight = gameHeight;

		targetElement.style.width = gameWidth+"px";
		targetElement.style.height = gameHeight+"px";

		this.layers = new Array();
		for (i in 0...numLayers)
		{
			if (i == 0)
				this.layers.push(new RenderLayer(this, i, targetElement, gameWidth, gameHeight, backgroundColor));
			else
				this.layers.push(new RenderLayer(this, i, targetElement, gameWidth, gameHeight));
		}

		var canvas:Dynamic = js.Lib.document.createElement("canvas"); 
		canvas.id = "gameCanvas";
		canvas.setAttribute("width", gameWidth+"px");
		canvas.setAttribute("height", gameHeight+"px");
		targetElement.appendChild(canvas);
		this.visiblePen = canvas.getContext("2d");

		this.canvas = js.Lib.document.createElement("canvas"); 
		this.canvas.id = "gameCanvasBuffer";
		this.canvas.setAttribute("width", gameWidth+"px");
		this.canvas.setAttribute("height", gameHeight+"px");
		this.pen = this.canvas.getContext("2d");
	}

	public function layerExists(layerId:Int):Bool
	{
		return 0 <= layerId && layerId < layers.length;
	}

	public function getLayer(layerId:Int):RenderLayer
	{
		if ( layerExists(layerId) )
		{
			return layers[layerId];
		}
		else
		{
			return null;
		}
	}

	public function clear():Void
	{
		for (layer in layers)
		{
			layer.clear();
		}

		this.visiblePen.clearRect(0, 0, this.gameWidth, this.gameHeight);
	}

	public function display():Void
	{
		this.pen.clearRect(0, 0, this.gameWidth, this.gameHeight);

		for (layer in layers)
		{
			layer.display(this.pen);
		}

		this.visiblePen.drawImage(this.canvas, 0, 0);
	}

	public function destroy():Void
	{
		while (layers.length != 0)
		{
			var layer:RenderLayer = layers.pop();
			layer.destroy();
		}
		layers = null;

		this.pen = null;
		this.canvas = null;

		this.visiblePen = null;
		var element:HtmlDom = js.Lib.document.getElementById("gameCanvas");
		element.parentNode.removeChild(element);
	}
}
