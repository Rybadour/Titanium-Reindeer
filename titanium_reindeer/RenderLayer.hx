package titanium_reindeer;

import titanium_reindeer.Enums;

import js.Dom;

typedef RendererSortData =
{
	posX:Int,
	id:Int
}

class RenderLayer
{
	public var layerManager(default, null):RenderLayerManager;

	public var id(default, null):Int;

	public var pen(default, null):Dynamic;
	private var canvas:Dynamic;

	public var clearColor(default, setClearColor):Color;
	private function setClearColor(color:Color):Color
	{
		if (color != null)
		{
			if (this.clearColor == null || color.equal(this.clearColor))
			{
				this.clearColor = color.getCopy();
				this.redrawBackground = true;
			}
		}

		return this.clearColor;
	}

	public var renderComposition(default, setRenderComposition):Composition;
	private function setRenderComposition(comp:Composition):Composition
	{
		if (comp != this.renderComposition)
		{
			this.renderComposition = comp;
			this.redrawBackground = true;
		}

		return this.renderComposition;
	}

	public var visible(default, setVisible):Bool;
	private function setVisible(value:Bool):Bool
	{
		if (value != this.visible)
		{
			this.visible = value;

			if (this.visible)
				this.redrawBackground = true;
		}

		return this.visible;
	}

	public var alpha(default, setAlpha):Float;
	private function setAlpha(value:Float):Float
	{
		if (value != this.alpha && value >= 0 && value <= 1)
		{
			this.alpha = value;
		}

		return this.alpha;
	}

	private var width:Int;
	private var height:Int;

	private var watchedOffset:WatchedVector2;

	public var renderOffset(getOffset, setOffset):Vector2;
	private function getOffset():Vector2
	{
		return watchedOffset;
	}
	private function setOffset(value:Vector2):Vector2
	{
		if ( value != null )
		{
			if ( watchedOffset != value && !watchedOffset.equal(value) )
			{
				watchedOffset.setVector2(value);
				offsetChanged();
				redrawBackground = true;
			}
		}

		return renderOffset;
	}

	public var redrawBackground:Bool;

	private var renderers:IntHash<RendererComponent>;
	private var renderersYetToRedraw:IntHash<Int>;
	private var renderersToRedraw:IntHash<Int>;

	private var clearing:Bool;

	// Constructor
	public function new(layerManager:RenderLayerManager, id:Int, targetElement:HtmlDom, width:Int, height:Int, ?clearColor:Color)
	{
		this.layerManager = layerManager;
		this.id = id;

		this.canvas = js.Lib.document.createElement("canvas"); 
		canvas.setAttribute("width", width+"px");
		canvas.setAttribute("height", height+"px");
		canvas.id = "layer"+this.id;
		this.pen = canvas.getContext("2d");

		this.width = width;
		this.height = height;
		this.clearColor = clearColor;
		this.renderComposition = Composition.SourceOver;
		this.visible = true;
		this.alpha = 1;
		this.watchedOffset = new WatchedVector2(0, 0, offsetChanged);

		this.renderers = new IntHash();

		this.redrawBackground = true;
	}

	private function offsetChanged():Void
	{
		if (renderers != null)
		{
			for (renderer in renderers)
			{
				renderer.timeForRedraw = true;
			}
		}
	}

	public function clear():Void
	{
		this.clearing = true;

		var renderersExcluded:IntHash<Int> = new IntHash();

		if (this.redrawBackground)
		{
			this.clearArea(0, 0, this.width, this.height);
		}
		else
		{
			if (renderersYetToRedraw != null)
			{
				// Exclude offscreen renderers from redraw logic
				for (renderer in this.renderers)
				{
					if (!renderer.enabled)
					{
						if ( renderersYetToRedraw.exists(renderer.id) )
						{
							renderersYetToRedraw.remove(renderer.id);
							renderersExcluded.set(renderer.id, renderer.id);
						}
					}

					var screenRect:Rect = new Rect(0, 0, this.width, this.height);
					if ( !Rect.isIntersecting(screenRect, renderer.getLastRectBounds(4)) &&
					     !Rect.isIntersecting(screenRect, renderer.getRectBounds(4)) )
					{
						if ( renderersYetToRedraw.exists(renderer.id) )
							renderersYetToRedraw.remove(renderer.id);
						else if ( renderersToRedraw.exists(renderer.id) )
							renderersToRedraw.remove(renderer.id);

						renderersExcluded.set(renderer.id, renderer.id);
						renderer.timeForRedraw = false;
					}
				}

				if (Lambda.count(renderersYetToRedraw) != 0)
				{
					this.finalizeRedrawList();
				}
			}

			if (this.renderersToRedraw != null)
			{
				var renderer:RendererComponent;
				var position:Vector2;
				var width:Float;
				var height:Float;
				for (id in this.renderersToRedraw)
				{
					renderer = this.renderers.get(id);
					position = renderer.lastRenderedPosition;
					width = renderer.lastRenderedWidth + 2;
					height = renderer.lastRenderedHeight + 2;

					this.clearArea(position.x - width/2, position.y - height/2, width, height);
				}
			}
		}

		if (this.renderersYetToRedraw != null)
		{
			if (this.renderersToRedraw != null)
			{
				for (id in this.renderersToRedraw)
					this.renderersYetToRedraw.set(id, id);

				for (id in renderersExcluded)
					this.renderersYetToRedraw.set(id, id);
			}
		}
	
		this.renderersToRedraw = new IntHash();
		this.clearing = false;
	}

	private function clearArea(x:Float, y:Float, width:Float, height:Float)
	{
		pen.clearRect(x, y, width, height);
	
		if (this.clearColor != null)
		{
			pen.fillStyle = this.clearColor.rgba;
			pen.fillRect(x-1, y-1, width+2, height+2);
		}
	}

	// Checks for other components on this layer if they need to be redraw
	// (due to the effects of other components being cleared over them)
	private function finalizeRedrawList():Void
	{
		// First build a sorted list of renderers yet to be redraw
		var sortedRenderers:Array<RendererSortData> = new Array();
		for (id in renderersYetToRedraw)
		{
			sortedRenderers.push({
				posX: Math.round(renderers.get(id).screenPos.x - renderers.get(id).drawnWidth),
				id: id
			});
		}
		sortedRenderers.sort(function (a:RendererSortData, b:RendererSortData)
		{
			return (a.posX == b.posX) ? 0 : ((a.posX < b.posX) ? -1 : 1);
		});

		// Catch any other components that intersect ones already being draw
		var sortedIndex:Int = 0;
		var sortedMin:Int;
		var sortedMax:Int;

		var newRenderers:Array<Int> = Lambda.array(renderersToRedraw);
		var nextRenderers:Array<Int> = new Array();
		var foundAny:Bool = true;

		var newRenderer:RendererComponent;
		var newRendererRight:Float;
		var renderer:RendererComponent;
		while (foundAny)
		{
			foundAny = false;
		
			for (id in newRenderers)
			{
				newRenderer = renderers.get(id);
				newRendererRight = newRenderer.screenPos.x + newRenderer.drawnWidth/2 + 1;
				sortedMin = 0;
				sortedMax = sortedRenderers.length;
				sortedIndex = 0;
				while ((sortedMax - sortedMin)/2 >= 1)
				{
					sortedIndex = sortedMin + Math.round((sortedMax - sortedMin)/2);

					if (newRendererRight < sortedRenderers[sortedIndex].posX)
					{
						sortedMax = sortedIndex;
					}
					else
					{
						sortedMin = sortedIndex;
					}
				}

				if (newRendererRight < sortedRenderers[sortedIndex].posX)
					--sortedIndex;

				var i:Int = sortedIndex;
				while (i >= 0)
				{
					renderer = renderers.get(sortedRenderers[i].id);
					if ( Rect.isIntersecting(newRenderer.getLastRectBounds(4), renderer.getRectBounds(4)) )
					{
						nextRenderers.push(renderer.id);
						renderersToRedraw.set(renderer.id, renderer.id);
						renderer.timeForRedraw = true;
						sortedRenderers.splice(i, 1);
						foundAny = true;
					}

					--i;
				}

				if (sortedRenderers.length == 0)
					break;
			}

			if (sortedRenderers.length == 0)
				break;

			if (foundAny)
			{
				newRenderers = Lambda.array(nextRenderers);
				nextRenderers = new Array();
			}
		}
	}

	// TODO: Consider doing renderOffset magic here
	public function display(screenPen:Dynamic):Void
	{
		if (this.visible && this.alpha > 0)
		{
			screenPen.save();

			screenPen.globalAlpha = this.alpha;
			screenPen.drawImage(this.canvas, 0, 0);

			screenPen.restore();
		}

		this.redrawBackground = false;
	}

	public function getVectorToScreen(vector:Vector2)
	{
		if (vector == null)
		{
			return renderOffset.getCopy();
		}

		return vector.add(renderOffset);
	}

	public function getVectorFromScreen(vector:Vector2)
	{
		return vector.subtract(renderOffset);
	}

	public function addRenderer(renderer:RendererComponent):Void
	{
		if ( !renderers.exists(renderer.id) )
		{
			this.ensureYetToRedrawIsReady();

			this.renderersYetToRedraw.set(renderer.id, renderer.id);

			renderers.set(renderer.id, renderer);
		}
	}

	public function removeRenderer(renderer:RendererComponent):Void
	{
		if (this.renderers.exists(renderer.id))
			this.renderers.remove(renderer.id);

		if (this.renderersToRedraw.exists(renderer.id))
			this.renderersToRedraw.remove(renderer.id);

		if (this.renderersYetToRedraw.exists(renderer.id))
			this.renderersYetToRedraw.remove(renderer.id);
	}

	public function redrawRenderer(renderer:RendererComponent):Void
	{
		if ( this.clearing || !this.renderers.exists(renderer.id) )
			return;

		if (this.renderersToRedraw == null)
			this.renderersToRedraw = new IntHash();

		this.ensureYetToRedrawIsReady();

		if (this.renderersYetToRedraw.exists(renderer.id))
		{
			this.renderersYetToRedraw.remove(renderer.id);
			this.renderersToRedraw.set(renderer.id, renderer.id);
		}
	}

	public function stopRedrawRenderer(renderer:RendererComponent):Void
	{
		if ( this.clearing || !this.renderers.exists(renderer.id) )
			return;

		if (this.renderersToRedraw == null)
			this.renderersToRedraw = new IntHash();

		this.ensureYetToRedrawIsReady();

		if (this.renderersToRedraw.exists(renderer.id))
		{
			this.renderersToRedraw.remove(renderer.id);
			this.renderersYetToRedraw.set(renderer.id, renderer.id);
		}
	}

	private function ensureYetToRedrawIsReady():Void
	{
		if (this.renderersYetToRedraw == null)
		{
			this.renderersYetToRedraw = new IntHash();
			for (rendererId in this.renderers.keys())
			{
				this.renderersYetToRedraw.set(rendererId, rendererId);
			}
		}
	}

	public function destroy():Void
	{
		this.layerManager = null;

		this.canvas = null;
		this.pen = null;

		this.clearColor = null;
		this.renderOffset = null;

		for (i in this.renderers.keys())
			this.renderers.remove(i);
		this.renderers = null;

		if (this.renderersYetToRedraw != null)
		{
			for (i in this.renderersYetToRedraw.keys())
				this.renderersYetToRedraw.remove(i);
			this.renderersYetToRedraw = null;
		}

		if (this.renderersYetToRedraw != null)
		{
			for (i in this.renderersToRedraw.keys())
				this.renderersToRedraw.remove(i);
			this.renderersToRedraw = null;
		}
	}
}
