package titanium_reindeer;

import js.Dom;
import titanium_reindeer.Enums;

enum InputEvent
{
	MouseDown;
	MouseUp;
	MouseMove;
	MouseWheel;
	KeyUp;
	KeyDown;

	MouseHeldEvent;
	KeyHeldEvent;
	MouseAnyEvent;
	KeyAnyEvent;
}

class RecordedEvent
{
	public var type:InputEvent;
	public var event:Dynamic;

	public function new(type:InputEvent, event:Dynamic)
	{
		this.type = type;
		this.event = event;
	}
}

class MouseButtonData
{
	public var button:MouseButton;
	public var buttonState:MouseButtonState;
	
	public var cb:Vector2 -> Void;

	public function new(button:MouseButton, buttonState:MouseButtonState, cb:Vector2 -> Void)
	{
		this.button = button;
		this.buttonState = buttonState;
		this.cb = cb;
	}
}

class MouseMoveData
{
	public var cb:Vector2 -> Void;

	public function new(cb:Vector2 -> Void)
	{
		this.cb = cb;
	}
}

class MouseWheelData
{
	public var cb:Int -> Void;

	public function new(cb:Int -> Void)
	{
		this.cb = cb;
	}
}

class MouseButtonAnyData
{
	public var cb:MouseButton -> MouseButtonState -> Vector2 -> Void;

	public function new(cb:MouseButton -> MouseButtonState -> Vector2 -> Void)
	{
		this.cb = cb;
	}
}

class KeyData
{
	public var key:Key;
	public var keyState:KeyState;
	public var cb:Void -> Void;

	public function new(key:Key, keyState:KeyState, cb:Void -> Void)
	{
		this.key = key;
		this.keyState = keyState;
		this.cb = cb;
	}
}

class KeyAnyData
{
	public var cb:Key -> KeyState -> Void;
	
	public function new(cb:Key -> KeyState -> Void)
	{
		this.cb = cb;
	}
}

class InputManager
{
	public static inline var DEFAULT_OFFSET_RECALC_DELAY_MS:Int		= 1000;


	private var mouseButtonsRegistered:IntHash<IntHash<Array<Vector2 -> Void>>>; // Array<(mousePos) -> Void>
		private var downMouseButtonsRegistered(getDownMouseButtonsRegistered, null):IntHash<Array<Vector2 -> Void>>;
		private function getDownMouseButtonsRegistered():IntHash<Array<Vector2 -> Void>>
		{ return mouseButtonsRegistered.get(Type.enumIndex(MouseButtonState.Down)); }
		private var heldMouseButtonsRegistered(getHeldMouseButtonsRegistered, null):IntHash<Array<Vector2 -> Void>>;
		private function getHeldMouseButtonsRegistered():IntHash<Array<Vector2 -> Void>>
		{ return mouseButtonsRegistered.get(Type.enumIndex(MouseButtonState.Held)); }
		private var upMouseButtonsRegistered(getUpMouseButtonsRegistered, null):IntHash<Array<Vector2 -> Void>>;
		private function getUpMouseButtonsRegistered():IntHash<Array<Vector2 -> Void>>
		{ return mouseButtonsRegistered.get(Type.enumIndex(MouseButtonState.Up)); }
	private var mouseButtonsAnyRegistered:Array<MouseButton -> MouseButtonState -> Vector2 -> Void>;
	private var mouseWheelsRegistered:Array<Int -> Void>; // Array<(ticks) -> Void>
	private var mousePositionChangesRegistered:Array<Vector2 -> Void>; // Array<(mousePos) -> Void>
	private var mouseButtonsHeld:IntHash<MouseButton>;
	private var lastMousePos:Vector2;
	
	public var mousePosition(getMousePos, null):Vector2;
	private function getMousePos():Vector2
	{
		return lastMousePos.getCopy();
	}

	private var keysRegistered:IntHash<IntHash<Array<Void -> Void>>>;
		private var downKeysRegistered(getDownKeysRegistered, null):IntHash<Array<Void -> Void>>;
		private function getDownKeysRegistered():IntHash<Array<Void -> Void>>
		{ return keysRegistered.get(Type.enumIndex(KeyState.Down)); }
		private var heldKeysRegistered(getHeldKeysRegistered, null):IntHash<Array<Void -> Void>>;
		private function getHeldKeysRegistered():IntHash<Array<Void -> Void>>
		{ return keysRegistered.get(Type.enumIndex(KeyState.Held)); }
		private var upKeysRegistered(getUpKeysRegistered, null):IntHash<Array<Void -> Void>>;
		private function getUpKeysRegistered():IntHash<Array<Void -> Void>>
		{ return keysRegistered.get(Type.enumIndex(KeyState.Up)); }
	private var keysAnyRegistered:Array<Key -> KeyState -> Void>;
	private var heldKeys:IntHash<Key>;

	private var recordedEvents:Array<RecordedEvent>;

	private var queuedMouseButtonRegisters:Array<MouseButtonData>;
	private var queuedMouseMoveRegisters:Array<MouseMoveData>;
	private var queuedMouseWheelRegisters:Array<MouseWheelData>;
	private var queuedMouseButtonAnyRegisters:Array<MouseButtonAnyData>;
	private var queuedKeyRegisters:Array<KeyData>;
	private var queuedKeyAnyRegisters:Array<KeyAnyData>;

	private var queuedMouseButtonUnregisters:Array<MouseButtonData>;
	private var queuedMouseMoveUnregisters:Array<MouseMoveData>;
	private var queuedMouseWheelUnregisters:Array<MouseWheelData>;
	private var queuedMouseButtonAnyUnregisters:Array<MouseButtonAnyData>;
	private var queuedKeyUnregisters:Array<KeyData>;
	private var queuedKeyAnyUnregisters:Array<KeyAnyData>;

	private var queueRegisters:Bool;

	private var targetElement:HtmlDom;
	private var targetDocumentOffset:Vector2;
	private var timeLeftToRecalculateOffsetMs:Int;

	public function new(targetElement:HtmlDom)
	{
		this.mouseButtonsRegistered = new IntHash();
			this.mouseButtonsRegistered.set(Type.enumIndex(MouseButtonState.Down), new IntHash());
			this.mouseButtonsRegistered.set(Type.enumIndex(MouseButtonState.Held), new IntHash());
			this.mouseButtonsRegistered.set(Type.enumIndex(MouseButtonState.Up), new IntHash());
		this.mouseButtonsAnyRegistered = new Array();
		this.mouseWheelsRegistered = new Array();
		this.mousePositionChangesRegistered = new Array();
		this.mouseButtonsHeld = new IntHash();

		this.lastMousePos = new Vector2(0, 0);

		this.keysRegistered = new IntHash();
			this.keysRegistered.set(Type.enumIndex(KeyState.Down), new IntHash());
			this.keysRegistered.set(Type.enumIndex(KeyState.Held), new IntHash());
			this.keysRegistered.set(Type.enumIndex(KeyState.Up), new IntHash());
		this.keysAnyRegistered = new Array();
		this.heldKeys = new IntHash();

		this.recordedEvents = new Array();

		this.queuedMouseButtonRegisters = new Array();
		this.queuedMouseMoveRegisters = new Array();
		this.queuedMouseWheelRegisters = new Array();
		this.queuedMouseButtonAnyRegisters = new Array();
		this.queuedKeyRegisters = new Array();
		this.queuedKeyAnyRegisters = new Array();

		this.queuedMouseButtonUnregisters = new Array();
		this.queuedMouseMoveUnregisters = new Array();
		this.queuedMouseWheelUnregisters = new Array();
		this.queuedMouseButtonAnyUnregisters = new Array();
		this.queuedKeyUnregisters = new Array();
		this.queuedKeyAnyUnregisters = new Array();

		this.queueRegisters = false;

		this.targetElement = targetElement;
		this.recalculateCanvasOffset();

		this.timeLeftToRecalculateOffsetMs = InputManager.DEFAULT_OFFSET_RECALC_DELAY_MS;

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

	private function recordEvent(type:InputEvent, event:Dynamic):Void
	{
		this.recordedEvents.push(new RecordedEvent(type, event));
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


	/*
		Input Event Handlers
		------------------------------------------------
	*/
	private function mouseDown(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);
		var mouseButton:MouseButton = getMouseButtonFromButton(event.button);

		mouseButtonsHeld.set(Type.enumIndex(mouseButton), mouseButton);

		for (cb in this.mouseButtonsAnyRegistered)
		{
			if (cb != null)
				cb(mouseButton, MouseButtonState.Down, mousePos.getCopy());
		}

		if ( downMouseButtonsRegistered.exists(Type.enumIndex(mouseButton)) )
		{
			var functions:Array<Vector2 -> Void> = downMouseButtonsRegistered.get(Type.enumIndex(mouseButton));
			for (cb in functions)
			{
				if (cb != null)
					cb(mousePos.getCopy());
			}
		}
	}

	private function mouseUp(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);
		var mouseButton:MouseButton = getMouseButtonFromButton(event.button);

		mouseButtonsHeld.remove(Type.enumIndex(mouseButton));

		for (cb in this.mouseButtonsAnyRegistered)
		{
			if (cb != null)
				cb(mouseButton, MouseButtonState.Up, mousePos.getCopy());
		}

		if ( upMouseButtonsRegistered.exists(Type.enumIndex(mouseButton)) )
		{
			var functions:Array<Vector2 -> Void> = upMouseButtonsRegistered.get(Type.enumIndex(mouseButton));
			for (cb in functions)
			{
				if (cb != null)
					cb(mousePos.getCopy());
			}
		}
	}

	private function mouseMove(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);

		for (cb in this.mousePositionChangesRegistered)
		{
			if (cb != null)
				cb(mousePos.getCopy());
		}

		this.lastMousePos = mousePos;
	}

	private function mouseWheel(event:Dynamic):Void
	{
		var ticks:Int = 0;

		var firefoxReg:EReg = new EReg("Firefox", "i");
		if (firefoxReg.match(js.Lib.window.navigator.userAgent))
			ticks = event.detail;
		else
			ticks = Math.round(event.wheelDelta / 120);

		for (cb in this.mouseWheelsRegistered)
		{
			if (cb != null)
				cb(ticks);
		}
	}

	private function keyDown(event:Event):Void
	{
		var keyCode:Int = event.keyCode; 
		var key:Key = getKeyFromCode(keyCode);

		heldKeys.set(Type.enumIndex(key), key);

		if ( downKeysRegistered.exists(Type.enumIndex(key)) )
		{
			var functions:Array<Void -> Void> = downKeysRegistered.get(Type.enumIndex(key));
			for (cb in functions)
			{
				if (cb != null)
					cb();
			}
		}
	}

	private function keyUp(event:Event):Void
	{
		var keyCode:Int = event.keyCode; 
		var key:Key = getKeyFromCode(keyCode);

		heldKeys.remove(Type.enumIndex(key));

		if ( upKeysRegistered.exists(Type.enumIndex(key)) )
		{
			var functions:Array<Void -> Void> = upKeysRegistered.get(Type.enumIndex(key));
			for (cb in functions)
			{
				if (cb != null)
					cb();
			}
		}
	}

	/*
		Usual Framework type Functions
		------------------------------------------------
	*/
	public function update(msTimeStep:Int):Void
	{
		// Get all recorded events into a temporary store so that new events don't affect the loop
		var tempEvents:Array<RecordedEvent> = new Array();
		for (recordedEvent in this.recordedEvents)
		{
			tempEvents.push(recordedEvent);
		}
		this.recordedEvents = new Array();

		// Call recorded events
		this.queueRegisters = true;
		for (recordedEvent in tempEvents)
		{
			var func:Dynamic -> Void;
			switch (recordedEvent.type)
			{
				case MouseDown:
					func = this.mouseDown;
				
				case MouseUp:
					func = this.mouseUp;
				
				case MouseMove:
					func = this.mouseMove;
				
				case MouseWheel:
					func = this.mouseWheel;
				
				case KeyDown:
					func = this.keyDown;
				
				case KeyUp:
					func = this.keyUp;

				default:
					func = null;
			}
			func(recordedEvent.event);
		}

		for (key in heldKeys)
		{
			if (heldKeysRegistered.exists(Type.enumIndex(key)))
			{
				var functions:Array<Void -> Void> = heldKeysRegistered.get(Type.enumIndex(key));
				for (cb in functions)
				{
					if (cb != null)
						cb();
				}
			}
		}

		for (mouseButton in mouseButtonsHeld)
		{
			if (heldMouseButtonsRegistered.exists(Type.enumIndex(mouseButton)))
			{
				for (cb in heldMouseButtonsRegistered.get(Type.enumIndex(mouseButton)))
				{
					if (cb != null)
						cb(this.lastMousePos);
				}
			}
		}

		this.queueRegisters = false;
		this.flushQueues();

		this.timeLeftToRecalculateOffsetMs -= msTimeStep;
		if (this.timeLeftToRecalculateOffsetMs <= 0)
		{
			this.timeLeftToRecalculateOffsetMs = InputManager.DEFAULT_OFFSET_RECALC_DELAY_MS;
			this.recalculateCanvasOffset();
		}
	}

	public function destroy():Void
	{
		for (mouseButtonState in mouseButtonsRegistered.keys())
		{
			for (mouseButton in mouseButtonsRegistered.get(mouseButtonState).keys())
			{
				var functions:Array<Vector2 -> Void> = mouseButtonsRegistered.get(mouseButtonState).get(mouseButton);
				functions.splice(0, functions.length);
				mouseButtonsRegistered.get(mouseButtonState).remove(mouseButton);
			}
			mouseButtonsRegistered.remove(mouseButtonState);
		}
		mouseButtonsRegistered = null;

		mouseButtonsAnyRegistered.splice(0, mouseButtonsAnyRegistered.length);
		mouseButtonsAnyRegistered = null;

		mouseWheelsRegistered.splice(0, mouseWheelsRegistered.length);
		mouseWheelsRegistered = null;

		mousePositionChangesRegistered.splice(0, mousePositionChangesRegistered.length);
		mousePositionChangesRegistered = null;

		for (mouseButton in mouseButtonsHeld.keys())
			mouseButtonsHeld.remove(mouseButton);
		mouseButtonsHeld = null;

		lastMousePos = null;

		for (mouseButtonState in keysRegistered.keys())
		{
			for (mouseButton in keysRegistered.get(mouseButtonState).keys())
			{
				var functions:Array<Void -> Void> = keysRegistered.get(mouseButtonState).get(mouseButton);
				functions.splice(0, functions.length);
				keysRegistered.get(mouseButtonState).remove(mouseButton);
			}
			keysRegistered.remove(mouseButtonState);
		}
		keysRegistered = null;

		for (key in heldKeys.keys())
			heldKeys.remove(key);
		heldKeys = null;

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

	/*
		Register Functions
		------------------------------------------------
	*/
	public function registerMouseButtonEvent(button:MouseButton, buttonState:MouseButtonState, cb:Vector2 -> Void):Void
	{
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseButtonRegisters.push(new MouseButtonData(button, buttonState, cb));
			return;
		}

		var buttons:IntHash<Array<Vector2 -> Void>> = mouseButtonsRegistered.get(Type.enumIndex(buttonState));
		if ( !buttons.exists(Type.enumIndex(button)) )
			buttons.set(Type.enumIndex(button), new Array());

		buttons.get(Type.enumIndex(button)).push(cb);
	}

	public function registerMouseButtonAnyEvent(cb:MouseButton -> MouseButtonState -> Vector2 -> Void):Void
	{
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseButtonAnyRegisters.push(new MouseButtonAnyData(cb));
			return;
		}

		this.mouseButtonsAnyRegistered.push(cb);
	}

	public function registerMouseMoveEvent(cb:Vector2 -> Void):Void
	{
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseMoveRegisters.push(new MouseMoveData(cb));
			return;
		}

		this.mousePositionChangesRegistered.push(cb);
	}

	public function registerMouseWheelEvent(cb:Int -> Void):Void
	{
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseWheelRegisters.push(new MouseWheelData(cb));
			return;
		}

		mouseWheelsRegistered.push(cb);
	}

	public function registerKeyEvent(key:Key, keyState:KeyState, cb:Void -> Void):Void
	{
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedKeyRegisters.push(new KeyData(key, keyState, cb));
			return;
		}
		
		var arr:IntHash<Array<Void -> Void>> = keysRegistered.get(Type.enumIndex(keyState));
		if ( !arr.exists(Type.enumIndex(key)) )
			arr.set(Type.enumIndex(key), new Array());

		arr.get(Type.enumIndex(key)).push(cb);
	}

	public function registerKeyAnyEvent(cb:Key -> KeyState -> Void):Void
	{
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedKeyAnyRegisters.push(new KeyAnyData(cb));
			return;
		}

		this.keysAnyRegistered.push(cb);
	}

	/*
		Unregister Functions
		------------------------------------------------
	*/
	public function unregisterMouseButtonEvent(mouseButton:MouseButton, mouseButtonState:MouseButtonState, cb:Vector2 -> Void):Void
	{	
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseButtonUnregisters.push(new MouseButtonData(mouseButton, mouseButtonState, cb));
			return;
		}

		var mouseButtons:IntHash<Array<Vector2 -> Void>> = mouseButtonsRegistered.get(Type.enumIndex(mouseButtonState));
		if ( mouseButtons.exists(Type.enumIndex(mouseButton)) )
		{
			var functions:Array<Vector2 -> Void> = mouseButtons.get(Type.enumIndex(mouseButton));
			for (i in 0...functions.length)
			{
				if (Reflect.compareMethods(functions[i], cb))
				{
					functions.splice(i, 1);
					break;
				}
			}
		}
	}

	public function unregisterMouseButtonAnyEvent(cb:MouseButton -> MouseButtonState -> Vector2 -> Void):Void
	{	
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseButtonAnyUnregisters.push(new MouseButtonAnyData(cb));
			return;
		}

		for (i in 0...this.mouseButtonsAnyRegistered.length)
		{
			if (Reflect.compareMethods(this.mouseButtonsAnyRegistered[i], cb))
			{
				this.mouseButtonsAnyRegistered.splice(i, 1);
				break;
			}
		}
	}

	public function unregisterMouseMoveEvent(cb:Vector2 -> Void):Void
	{	
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseMoveUnregisters.push(new MouseMoveData(cb));
			return;
		}

		for (i in 0...mousePositionChangesRegistered.length)
		{
			if (Reflect.compareMethods(mousePositionChangesRegistered[i], cb))
			{
				mousePositionChangesRegistered.splice(i, 1);
				break;
			}
		}
	}

	public function unregisterMouseWheelEvent(cb:Int -> Void):Void
	{	
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedMouseWheelUnregisters.push(new MouseWheelData(cb));
			return;
		}

		for (i in 0...mouseWheelsRegistered.length)
		{
			if (Reflect.compareMethods(mouseWheelsRegistered[i], cb))
			{
				mouseWheelsRegistered.splice(i, 1);
				break;
			}
		}
	}

	public function unregisterKeyEvent(key:Key, keyState:KeyState, cb:Void -> Void):Void
	{	
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedKeyUnregisters.push(new KeyData(key, keyState, cb));
			return;
		}

		var keys:IntHash<Array<Void -> Void>> = keysRegistered.get(Type.enumIndex(keyState));
		
		if ( keys.exists(Type.enumIndex(key)) )
		{
			var functions:Array<Void -> Void> = keys.get(Type.enumIndex(key));
			for (i in 0...functions.length)
			{
				if (Reflect.compareMethods(functions[i], cb))
				{
					functions.splice(i, 1);
					break;
				}
			}
		}
	}

	public function unregisterKeyAnyEvent(cb:Key -> KeyState -> Void):Void
	{	
		if (cb == null)
			return;

		if (this.queueRegisters)
		{
			this.queuedKeyAnyUnregisters.push(new KeyAnyData(cb));
			return;
		}

		for (i in 0...this.keysAnyRegistered.length)
		{
			if (Reflect.compareMethods(this.keysAnyRegistered[i], cb))
			{
				this.keysAnyRegistered.splice(i, 1);
				break;
			}
		}
	}

	private function flushQueues():Void
	{
		for (data in this.queuedMouseButtonRegisters)
			this.registerMouseButtonEvent(data.button, data.buttonState, data.cb);
		this.queuedMouseButtonRegisters = new Array();

		for (data in this.queuedMouseMoveRegisters)
			this.registerMouseMoveEvent(data.cb);
		this.queuedMouseMoveRegisters = new Array();

		for (data in this.queuedMouseWheelRegisters)
			this.registerMouseWheelEvent(data.cb);
		this.queuedMouseWheelRegisters = new Array();

		for (data in this.queuedMouseButtonAnyRegisters)
			this.registerMouseButtonAnyEvent(data.cb);
		this.queuedMouseButtonAnyRegisters = new Array();

		for (data in this.queuedKeyRegisters)
			this.registerKeyEvent(data.key, data.keyState, data.cb);
		this.queuedKeyRegisters = new Array();

		for (data in this.queuedKeyAnyRegisters)
			this.registerKeyAnyEvent(data.cb);
		this.queuedKeyAnyRegisters = new Array();


		for (data in this.queuedMouseButtonUnregisters)
			this.unregisterMouseButtonEvent(data.button, data.buttonState, data.cb);
		this.queuedMouseButtonUnregisters = new Array();

		for (data in this.queuedMouseMoveUnregisters)
			this.unregisterMouseMoveEvent(data.cb);
		this.queuedMouseMoveUnregisters = new Array();

		for (data in this.queuedMouseWheelUnregisters)
			this.unregisterMouseWheelEvent(data.cb);
		this.queuedMouseWheelUnregisters = new Array();

		for (data in this.queuedMouseButtonAnyUnregisters)
			this.unregisterMouseButtonAnyEvent(data.cb);
		this.queuedMouseButtonAnyUnregisters = new Array();

		for (data in this.queuedKeyUnregisters)
			this.unregisterKeyEvent(data.key, data.keyState, data.cb);
		this.queuedKeyUnregisters = new Array();

		for (data in this.queuedKeyAnyUnregisters)
			this.unregisterKeyAnyEvent(data.cb);
		this.queuedKeyAnyUnregisters = new Array();
	}


	/*
		Current state getter functions
		------------------------------------------
	*/
	public function isMouseButtonDown(mouseButton:MouseButton):Bool
	{
		return mouseButtonsHeld.exists(Type.enumIndex(mouseButton));
	}

	public function isKeyDown(key:Key):Bool
	{
		return heldKeys.exists(Type.enumIndex(key));
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
	}

	/*
		Key and Button Mapping functions	
		------------------------------------------
	*/
	private function getMousePositionFromEvent(event:Dynamic):Vector2
	{
		if (event == null)
			return new Vector2(0, 0);

		var mousePos:Vector2;
		if (event.pageX || event.pageY)
			 mousePos = new Vector2(event.pageX, event.pageY);

		else if (event.clientX || event.clientY)
			untyped
			{
				mousePos = new Vector2( event.clientX + js.Lib.document.body.scrollLeft + js.Lib.document.documentElement.scrollLeft,
										event.clientY + js.Lib.document.body.scrollTop + js.Lib.document.documentElement.scrollTop);
			}

		else
			return new Vector2(0, 0);

		return mousePos.subtract(this.targetDocumentOffset);
	}

	private function getMouseButtonFromButton(which:Int):MouseButton
	{
		var mouseButton:MouseButton;
		switch (which)
		{
			case 0: mouseButton = MouseButton.Left;
			case 1: mouseButton = MouseButton.Middle;
			case 2: mouseButton = MouseButton.Right;

			default: mouseButton = MouseButton.Left;
		}

		return mouseButton;
	}

	private function getKeyFromCode(keyCode:Int):Key
	{
		var key:Key;
		switch (keyCode)
		{
			case 8: key = Key.BackSpace;
			case 9: key = Key.Tab;
			case 13: key = Key.Enter;
			case 16: key = Key.Shift;
			case 17: key = Key.Ctrl;
			case 18: key = Key.Alt;
			case 20: key = Key.CapsLock;
			case 27: key = Key.Esc;
			case 32: key = Key.Space;

			case 33: key = Key.PageUp;
			case 34: key = Key.PageDown;
			case 35: key = Key.End;
			case 36: key = Key.Home;
			
			case 37: key = Key.LeftArrow;
			case 38: key = Key.UpArrow;
			case 39: key = Key.RightArrow;
			case 40: key = Key.DownArrow;

			case 45: key = Key.Insert;
			case 46: key = Key.Delete;

			case 48: key = Key.Zero;
			case 49: key = Key.One;
			case 50: key = Key.Two;
			case 51: key = Key.Three;
			case 52: key = Key.Four;
			case 53: key = Key.Five;
			case 54: key = Key.Six;
			case 55: key = Key.Seven;
			case 56: key = Key.Eight;
			case 57: key = Key.Nine;

			case 65: key = Key.A;
			case 66: key = Key.B;
			case 67: key = Key.C;
			case 68: key = Key.D;
			case 69: key = Key.E;
			case 70: key = Key.F;
			case 71: key = Key.G;
			case 72: key = Key.H;
			case 73: key = Key.I;
			case 74: key = Key.J;
			case 75: key = Key.K;
			case 76: key = Key.L;
			case 77: key = Key.M;
			case 78: key = Key.N;
			case 79: key = Key.O;
			case 80: key = Key.P;
			case 81: key = Key.Q;
			case 82: key = Key.R;
			case 83: key = Key.S;
			case 84: key = Key.T;
			case 85: key = Key.U;
			case 86: key = Key.V;
			case 87: key = Key.W;
			case 88: key = Key.X;
			case 89: key = Key.Y;
			case 90: key = Key.Z;

			case 97: key = Key.NumOne;
			case 98: key = Key.NumTwo;
			case 99: key = Key.NumThree;
			case 100: key = Key.NumFour;
			case 101: key = Key.NumFive;
			case 102: key = Key.NumSix;
			case 103: key = Key.NumSeven;
			case 104: key = Key.NumEight;
			case 105: key = Key.NumNine;
			case 106: key = Key.NumAsterick;
			case 107: key = Key.NumPlus;
			case 109: key = Key.NumDash;
			case 111: key = Key.NumSlash;

			case 112: key = Key.F1;
			case 113: key = Key.F2;
			case 114: key = Key.F3;
			case 115: key = Key.F4;
			case 116: key = Key.F5;
			case 117: key = Key.F6;
			case 118: key = Key.F7;
			case 119: key = Key.F8;
			case 120: key = Key.F9;
			case 121: key = Key.F10;
			case 122: key = Key.F11;
			case 123: key = Key.F12;

			case 144: key = Key.NumLock;
			case 186: key = Key.SemiColon;
			case 187: key = Key.Equals;
			case 188: key = Key.Comma;
			case 189: key = Key.Dash;
			case 190: key = Key.Period;
			case 191: key = Key.Slash;
			case 192: key = Key.Tilde;
			case 219: key = Key.LeftBracket;
			case 220: key = Key.BackSlash;
			case 221: key = Key.LeftBracket;
			case 222: key = Key.Quote;

			default: key = Key.None;
		}

		return key;
	}
}
