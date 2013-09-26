package titanium_reindeer;

import js.Dom;
import titanium_reindeer.Enums;
import titanium_reindeer.InputManager;

class GameInputManager extends InputManager
{
	public static inline var DEFAULT_OFFSET_RECALC_DELAY_MS:Int		= 1000;


	private var game:Game;
	private var targetElement:HtmlDom;
	private var timeLeftToRecalculateOffsetMs:Int;

	private var keyDowns:IntHash<Bool>;

	public function new(game:Game, targetElement:HtmlDom)
	{
		super();

		this.game = game;
		this.targetElement = targetElement;
		this.recalculateCanvasOffset();

		this.keyDowns = new IntHash();

		this.timeLeftToRecalculateOffsetMs = DEFAULT_OFFSET_RECALC_DELAY_MS;

		untyped
		{
			var me = this;
			targetElement.onmousedown = function(event) { me.recordEvent(InputEvent.MouseDown, event); };
			targetElement.onmouseup = function(event) { me.recordEvent(InputEvent.MouseUp, event); };
			targetElement.onmousemove = function(event) { me.recordEvent(InputEvent.MouseMove, event); };

			targetElement.oncontextmenu = this.contextMenu;

			var firefoxReg:EReg = new EReg("Firefox", "i");
			var wheelFunc = function(event) { me.recordEvent(InputEvent.MouseWheel, event); };
			if (firefoxReg.match(js.Lib.window.navigator.userAgent))
				js.Lib.document.addEventListener("DOMMouseScroll", wheelFunc, true);
			else
				js.Lib.document.onmousewheel = wheelFunc;

			js.Lib.document.onkeydown = function(event) { me.recordEvent(InputEvent.KeyDown, event); };
			js.Lib.document.onkeyup = function(event) { me.recordEvent(InputEvent.KeyUp, event); };
		}
	}

	private function contextMenu(event:Dynamic):Bool
	{
		var found:Bool = false;
		if ( upMouseButtonsRegistered.exists(Type.enumIndex(MouseButton.Right)) )
		{
			found = upMouseButtonsRegistered.get(Type.enumIndex(MouseButton.Right)).length != 0;
		}

		return !(found || this.mouseButtonsAnyRegistered.length != 0);
	}

	private function recordEvent(type:InputEvent, event:Dynamic):Void
	{
		if (type == InputEvent.KeyDown)
		{
			var key:Int = event.keyCode; 
			if (this.keyDowns.exists(key) && this.keyDowns.get(key))
				return;

			this.keyDowns.set(key, true);
		}
		else if (type == InputEvent.KeyUp)
		{
			var key:Int = event.keyCode; 
			this.keyDowns.set(key, false);
		}

		this.recordedEvents.push(new RecordedEvent(type, event));
	}

	public override function update(msTimeStep:Int):Void
	{
		super.update(msTimeStep);

		// Get all recorded events into a temporary store so that new events don't affect the loop
		var tempEvents:Array<RecordedEvent> = new Array();
		for (recordedEvent in this.recordedEvents)
		{
			tempEvents.push(recordedEvent);
		}
		this.recordedEvents = new Array();

		// Call recorded events
		var scenes:Iterator<Scene> = this.game.sceneManager.getAllScenes();
		for (recordedEvent in tempEvents)
		{
			this.receiveEvent(recordedEvent);

			for (scene in scenes)
				scene.inputManager.receiveEvent(recordedEvent);
		}
	}

	public override function postUpdate(msTimeStep:Int):Void
	{
		super.postUpdate(msTimeStep);

		this.timeLeftToRecalculateOffsetMs -= msTimeStep;
		if (this.timeLeftToRecalculateOffsetMs <= 0)
		{
			this.timeLeftToRecalculateOffsetMs = DEFAULT_OFFSET_RECALC_DELAY_MS;
			this.recalculateCanvasOffset();
		}
	}

	public override function destroy():Void
	{
		super.destroy();

		untyped
		{
			this.targetElement.onmousedown = null;
			this.targetElement.onmouseup = null;
			this.targetElement.onmousemove = null;

			this.targetElement.oncontextmenu = null;
			js.Lib.document.onmousewheel = null;
			js.Lib.document.onkeydown = null;
			js.Lib.document.onkeyup = null;
			var firefoxReg:EReg = new EReg("Firefox", "i");
			if (firefoxReg.match(js.Lib.window.navigator.userAgent))
				js.Lib.document.removeEventListener("DOMMouseScroll", this.mouseWheel, true);
			else
				js.Lib.document.onmousewheel = null;
		}
		this.targetElement = null;
	}

	public function recalculateCanvasOffset():Void
	{
		var offset:Vector2 = new Vector2(0, 0);

		if (this.targetElement != null && this.targetElement.offsetParent != null)
		{
			var ele:HtmlDom = this.targetElement;
			do
			{
				offset.x += ele.offsetLeft;
				offset.y += ele.offsetTop;
				ele = ele.offsetParent;
			}
			while (ele != null);
		}

		this.targetDocumentOffset = offset;
		for (scene in this.game.sceneManager.getAllScenes())
		{
			scene.inputManager.setDocumentOffset(offset);
		}
	}
}
