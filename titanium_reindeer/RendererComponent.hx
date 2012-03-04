package titanium_reindeer;

import js.Dom;
import titanium_reindeer.Enums;

class RendererComponent extends Component
{
	public var rendererManager(getRendererManager, null):RendererComponentManager;
	public function getRendererManager():RendererComponentManager
	{
		if (this.manager == null)
			return null;
		else
			return cast(this.manager, RendererComponentManager);
	}

	private var layerNum:Int;

	public var layer(default, null):RenderLayer;
	public function setLayer(layerId:Int):Void
	{
		if (this.layer != null)
		{
			if (this.layer.id == layerId)
				return;

			this.layer.removeRenderer(this);
		}

		var layerManager:RenderLayerManager = this.rendererManager.renderLayerManager;

		if ( layerManager.layerExists(layerId) )
		{
			this.layer = layerManager.getLayer(layerId);
			this.layer.addRenderer(this);
		}
		else
			throw "RendererComponent: Attempting to add renderer to a non-existant layer ("+layerId+")!";
	}

	public var pen(getPen, never):Dynamic;
	public function getPen():Dynamic
	{
		if (this.useFakes)
			return this.fakePen;

		if (this.layer == null)
			return null;
		else
			return this.layer.pen;
	}

	private var watchedOffset:WatchedVector2;

	public var offset(getOffset, setOffset):Vector2;
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

 				// Note: This it is "good" convention to never call the vector changed function here
				// because child classes cannnot override the function to capture the event properly
				this.timeForRedraw = true;
			}
		}

		return offset;
	}

	public var drawnWidth(default, null):Float;
	private var initialDrawnWidth(default, setInitialWidth):Float;
	private function setInitialWidth(value:Float):Float
	{
		if (value < 0)
			value = 0;

		if (this.initialDrawnWidth != value)
		{
			this.initialDrawnWidth = value;

			this.recalculateDrawnWidthAndHeight();
			this.timeForRedraw = true;
		}

		return this.initialDrawnWidth;
	}

	public var drawnHeight(default, null):Float;
	private var initialDrawnHeight(default, setInitialHeight):Float;
	private function setInitialHeight(value:Float):Float
	{
		if (value < 0)
			value = 0;

		if (this.initialDrawnHeight != value)
		{
			this.initialDrawnHeight = value;

			this.recalculateDrawnWidthAndHeight();
			this.timeForRedraw = true;
		}

		return this.initialDrawnHeight;
	}

	// Now set the actual width and height
	private function recalculateDrawnWidthAndHeight():Void
	{
		var width:Float = this.initialDrawnWidth;
		var height:Float = this.initialDrawnHeight;
		if (shadow != null && shadow.color.alpha > 0)
		{
			width += Math.abs(shadow.offset.x)*2 + shadow.blur;
			height += Math.abs(shadow.offset.y)*2 + shadow.blur;
		}

		if (this.rotation != 0)
		{
			var hypot:Float = Math.sqrt(width*width + height*height);
			width = hypot;
			height = hypot;
		}

		this.drawnWidth = width;
		this.drawnHeight = height;
	}

	public var shadow(default, setShadow):Shadow;
	private function setShadow(value:Shadow):Shadow
	{
		if (value != null)
		{
			if (shadow == null || !value.equal(shadow))
			{
				shadow = value;

				this.recalculateDrawnWidthAndHeight();
				this.timeForRedraw = true;
			}
		}

		return shadow;
	}

	public var rotation(default, setRotation):Float;
	private function setRotation(value:Float):Float
	{
		 value %= Math.PI*2;

		if (value != this.rotation)
		{
			this.rotation = value;

			this.recalculateDrawnWidthAndHeight();
			this.timeForRedraw = true;
		}

		return rotation;
	}

	public var alpha(default, setAlpha):Float;
	private function setAlpha(value:Float):Float
	{
		if (value < 0)
			value = 0;
		else if (value > 1)
			value = 1;

		if (value != alpha)
		{
			alpha = value;
			this.timeForRedraw = true;
		}

		return alpha;
	}

	public var renderComposition(getRenderComposition, null):Composition;
	private function getRenderComposition():Composition
	{
		if (this.layer == null)
			return Composition.SourceOver;
		else
			return this.layer.renderComposition;
	}

	public var screenPos(getScreenPos, null):Vector2;
	public function getScreenPos():Vector2
	{
		if (this.useFakes)
			return this.fakePosition;

		if (this.layer == null)
			return new Vector2(0, 0);

		if (this.owner == null)
			return this.layer.getVectorToScreen(new Vector2(0, 0)).add(this.offset);
		else
			return this.layer.getVectorToScreen(this.owner.position).add(this.offset);
	}

	public var timeForRedraw(default, setRedraw):Bool;
	public function setRedraw(value:Bool):Bool
	{	
		if (value)
			recreateBitmapData();

		if (value && !this.timeForRedraw)
		{
			if (layer != null)		
				layer.redrawRenderer(this);

			this.timeForRedraw = true;
		}
		else if (!value && this.timeForRedraw)
		{
			if (layer != null)
				layer.stopRedrawRenderer(this);

			this.timeForRedraw = false;
		}

		return this.timeForRedraw;
	}

	public var lastRenderedPosition(default, null):Vector2;
	public var lastRenderedWidth(default, null):Float;
	public var lastRenderedHeight(default, null):Float;

	public var visible(getVisible, setVisible):Bool;
	private function getVisible():Bool
	{
		return this.enabled;
	}
	private function setVisible(value:Bool):Bool
	{
		this.enabled = value;
		return this.enabled;
	}
	// also override the enable set
	override public function setEnabled(value:Bool):Bool
	{
		this.timeForRedraw = true;

		return super.setEnabled(value);
	}

	private var effects:Hash<BitmapEffect>;

	private var lastIdentifier:String;

	public var sharedBitmap(default, null):ImageSource;
	public var usingSharedBitmap(default, null):Bool;

	private var effectWorker:Dynamic;

	private var useFakes:Bool;
	private var fakePen:Dynamic;
	private var fakePosition:Vector2;


	// FUNCTIONS
	// -------------------------------------------------------------------
	public function new(width:Float, height:Float, layer:Int)
	{
		super();

		this.initialDrawnWidth = width;
		this.initialDrawnHeight = height;
		this.layerNum = layer;
		
		this.alpha = 1;
		this.shadow = new Shadow(new Color(0, 0, 0, 0), new Vector2(0, 0), 0);
		this.rotation = 0;

		this.watchedOffset = new WatchedVector2(0, 0, offsetChanged);

		this.effects = new Hash();

		this.lastIdentifier = "";
		this.lastRenderedPosition = new Vector2(0, 0);

		this.useFakes = false;
	}

	override public function getManagerType():Class<ComponentManager>
	{
		return RendererComponentManager;
	}

	override public function initialize():Void
	{
		setLayer(this.layerNum);

		this.timeForRedraw = true;
	}

	override public function notifyPositionChange():Void
	{
		this.timeForRedraw = true;
	}

	private function offsetChanged():Void
	{
		this.timeForRedraw = true;
	}

	// This function serves to reposition renderers when a rotation is applied
	private function fixRotationOnPoint(p:Vector2):Void
	{
		if (this.rotation != 0)
		{
			var rotatedPoint:Vector2 = p.getRotate(this.rotation - 2*Math.PI);
			pen.translate(p.x - rotatedPoint.x, p.y - rotatedPoint.y);
		}
	}

	public function preRender():Void
	{
		pen.save();
		pen.globalCompositeOperation = RendererComponent.CompositionToString(this.renderComposition);
		pen.translate(this.screenPos.x, this.screenPos.y);

		if (this.rotation != 0)
		{
			pen.rotate(this.rotation);
		}

		pen.globalAlpha = this.alpha;

		pen.shadowColor = this.shadow.color.rgba;
		pen.shadowOffsetX = this.shadow.offset.x;
		pen.shadowOffsetY = this.shadow.offset.y;
		pen.shadowBlur = this.shadow.blur;
	}

	public function render():Void
	{	
	}
	
	public function postRender():Void
	{
		this.timeForRedraw = false;
		pen.restore();
	}

	public function renderSharedBitmap():Void
	{
		if (this.sharedBitmap != null)
		{
			this.pen.drawImage(
				this.sharedBitmap.image,
				this.screenPos.x - (this.drawnWidth/2 + 1),
				this.screenPos.y - (this.drawnHeight/2 + 1)
			);
		}
	}

	public function setLastRendered():Void
	{
		this.lastRenderedPosition = this.screenPos.getCopy();
		this.lastRenderedWidth = this.drawnWidth;
		this.lastRenderedHeight = this.drawnHeight;
	}

	public function identify():String
	{
		var identifier:String = "";
		for (effect in effects)
		{
			if (identifier != "")
				identifier += ",";
			identifier += effect.identify();
		}
		return "Renderer("+Math.round(this.drawnWidth)+","+Math.round(this.drawnHeight)+","+this.alpha+","+this.shadow.identify()+","+this.rotation+",Effects("+ identifier +"));";
	}

	public function addEffect(name:String, effect:BitmapEffect):Void
	{
		this.effects.set(name, effect);

		this.timeForRedraw = true;
	}

	public function removeEffect(name:String):Void
	{
		this.effects.remove(name);

		this.timeForRedraw = true;
	}

	public function useAlternateCanvas(pen:Dynamic, ?newPosition:Vector2):Void
	{
		this.fakePen = pen;
		if (newPosition == null)
			this.fakePosition = new Vector2(this.drawnWidth/2 + 1, this.drawnHeight/2 + 1);
		else
			this.fakePosition = newPosition;
		this.useFakes = true;
	}

	public function disableAlternateCanvas():Void
	{
		this.fakePen = null;
		this.fakePosition = null;
		this.useFakes = false;
	}

	private function recreateBitmapData():Void
	{
		// If there is some manager to handle our activities, and some effects (making this caching necessary)
		if (this.rendererManager != null && Lambda.count(this.effects) != 0)
		{
			var identifier:String = this.identify();
			if (this.lastIdentifier == identifier)
				return;

			this.lastIdentifier = identifier;

			this.usingSharedBitmap = true;

			// Use whats already there
			if ( this.rendererManager.cachedBitmaps.exists(identifier) )
				this.sharedBitmap = this.rendererManager.cachedBitmaps.get(identifier);
			else
			{
				// Time to setup some cached bitmap data to share
				var canvas:Dynamic = js.Lib.document.createElement("canvas");
				canvas.setAttribute("width", (this.drawnWidth+2)+"px");
				canvas.setAttribute("height", (this.drawnHeight+2)+"px");
				this.useAlternateCanvas(canvas.getContext("2d"), new Vector2(this.drawnWidth/2 + 1, this.drawnHeight/2 + 1));

				// Since we set the object to render to a fake canvas this will fill our temp canvas with bitmap data
				this.preRender();
				this.render();
				this.postRender();

				var bitmapData:BitmapData = new BitmapData(this.fakePen, new Rect(0, 0, this.drawnWidth+2, this.drawnHeight+2));
				/* *
				if (Utility.browserHasWebWorkers())
				{
					untyped
					{
						__js__('this.effectWorker = new Worker("worker.js")');
					}
					this.effectWorker.addEventListener("message", this.effectWorkerFinished, false);
					this.effectWorker.postMessage({bitmap: bitmapData, effects: effects, identifier: identifier});
				}
				else
				/* */
				{
					for (effect in this.effects)
						effect.apply(bitmapData);
					this.fakePen.clearRect(0, 0, this.drawnWidth+2, this.drawnHeight+2);
					this.fakePen.putImageData(bitmapData.rawData, 0, 0);

					var bitmap:ImageSource = new ImageSource(canvas.toDataURL("image/png"));
					if (bitmap.isLoaded)
						this.cachedBitmapLoaded(null);
					else
						bitmap.registerLoadEvent(this.cachedBitmapLoaded);
					sharedBitmap = bitmap;
					this.rendererManager.cachedBitmaps.set(identifier, bitmap);
				}
				
				this.disableAlternateCanvas();
			}
		}
		else
		{
			this.usingSharedBitmap = false;
			this.lastIdentifier = "";
		}
	}

	/* *
	private function effectWorkerFinished(event:Dynamic):Void
	{
		var canvas:Dynamic = js.Lib.document.createElement("canvas");
		canvas.setAttribute("width", (this.width+2)+"px");
		canvas.setAttribute("height", (this.height+2)+"px");
		var pen:Dynamic = canvas.getContext("2d");

		this.pen.putImageData(event.data.rawData, 0, 0);

		var bitmap:ImageSource = new ImageSource(canvas.toDataURL("image/png"));
		bitmap.registerLoadEvent(cachedBitmapLoaded);
		sharedBitmap = bitmap;
		usingSharedBitmap = true;
		rendererManager.cachedBitmaps.set(event.data.identifier, bitmap);

		canvas = null;
		pen = null;
	}
	/* */

	private function cachedBitmapLoaded(event:Event):Void
	{
		this.timeForRedraw = true;
	}

	public function getRectBounds(extraEdgeSize:Int):Rect
	{
		var width:Float = this.drawnWidth + extraEdgeSize;
		var height:Float = this.drawnHeight + extraEdgeSize;

		return new Rect(
			this.screenPos.x - width/2,
			this.screenPos.y - height/2,
			width,
			height
		);
	}

	public function getLastRectBounds(extraEdgeSize:Int):Rect
	{
		var width:Float = this.lastRenderedWidth + extraEdgeSize;
		var height:Float = this.lastRenderedHeight + extraEdgeSize;

		return new Rect(
			this.lastRenderedPosition.x - width/2,
			this.lastRenderedPosition.y - height/2,
			width,
			height
		);
	}

	// INTERNAL ONLY
	override public function finalDestroy():Void
	{
		super.finalDestroy();

		this.layer.removeRenderer(this);
		this.layer.stopRedrawRenderer(this);
		this.layer = null;

		this.fakePen = null;
		this.fakePosition = null;

		this.watchedOffset.destroy();
		this.watchedOffset = null;

		this.lastRenderedPosition = null;
		this.timeForRedraw = false;

		this.shadow = null;

		for (name in this.effects.keys())
		{
			this.effects.get(name).destroy();
			this.effects.remove(name);
		}
		this.effects = null;

		this.sharedBitmap = null;
	}


	public static function CompositionToString(comp:Composition):String
	{
		return switch (comp)
		{
			case SourceAtop: 		"source-atop";
			case SourceIn: 			"source-in";
			case SourceOut: 		"source-out";
			case SourceOver:		"source-over";
			case DestinationAtop: 	"destination-atop";
			case DestinationIn:     "destination-in";
			case DestinationOut:  	"destination-out";
			case DestinationOver: 	"destination-over";
			case Lighter: 			"lighter";
			case Copy: 				"copy";
			case Xor:				"xor";
		}
	}
}
