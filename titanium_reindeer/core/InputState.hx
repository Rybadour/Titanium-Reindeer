package titanium_reindeer.core;

import js.html.Element;

import titanium_reindeer.Enums;
import titanium_reindeer.spatial.Vector2;

/**
 * A helper class for storing a captured event.
 */
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

/**
 * The InputState class keeps of track input events of every kind. Only the current frame's input
 * events are kept in place. Each frame the previous events are forgotten and new events begin to
 * get recorded. Lookup to the InputState should be synchronous and each question about state to it
 * refers only to the state of things between the beginning of the current frame and the time the
 * question was asked.
 */
class InputState
{
	// TODO: Get rid of this eventually
	// Determines how often we check the window position of our target element
	// Used to accurately find the mouse position in the browser window
	public static inline var DEFAULT_OFFSET_RECALC_DELAY_MS:Int		= 1000;


	private var targetElement:Element;
	private var timeLeftToRecalculateOffsetMs:Int;

	private var mouseButtonsHeld:Map<Int, MouseButton>;
	private var heldKeys:Map<Int, Key>;
	
	public var mousePos(default, null):Vector2;

	private var recordedEvents:Array<RecordedEvent>;

	/* *
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
	/* */

	private var queueRegisters:Bool;

	private var targetDocumentOffset:Vector2;

	public function new(targetElement:Element)
	{
		this.targetElement = targetElement;
		this.timeLeftToRecalculateOffsetMs = DEFAULT_OFFSET_RECALC_DELAY_MS;

		this.mouseButtonsHeld = new Map();

		this.mousePos = new Vector2(0, 0);
		this.heldKeys = new Map();

		var me = this;
		this.targetElement.onmousedown = function(event) { me.recordEvent(InputEvent.MouseDown, event); };
		this.targetElement.onmouseup = function(event) { me.recordEvent(InputEvent.MouseUp, event); };
		this.targetElement.onmousemove = function(event) { me.recordEvent(InputEvent.MouseMove, event); };

		this.targetElement.oncontextmenu = this.contextMenu;

		var firefoxReg:EReg = new EReg("Firefox", "i");
		var wheelFunc = function(event) { me.recordEvent(InputEvent.MouseWheel, event); };
		if (firefoxReg.match(js.Browser.window.navigator.userAgent))
			js.Browser.document.addEventListener("DOMMouseScroll", wheelFunc, true);
		else
			js.Browser.document.onmousewheel = wheelFunc;

		js.Browser.document.onkeydown = function(event) { me.recordEvent(InputEvent.KeyDown, event); };
		js.Browser.document.onkeyup = function(event) { me.recordEvent(InputEvent.KeyUp, event); };

		this.recordedEvents = new Array();

		/* *
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
		/* */

		this.targetDocumentOffset = new Vector2(0, 0);
	}

	private function contextMenu(event:Dynamic):Bool
	{
		// TODO: Set a state to check 
		return false;
	}

	/*
		Input Event Handlers
		------------------------------------------------
	*/
	private function recordEvent(type:InputEvent, event:Dynamic):Void
	{
		var func:Dynamic -> Void;
		switch (type)
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
		func(event);

		//this.recordedEvents.push(new RecordedEvent(type, event));
	}

	private function mouseDown(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);
		var mouseButton:MouseButton = getMouseButtonFromButton(event.button);

		mouseButtonsHeld.set(Type.enumIndex(mouseButton), mouseButton);
	}

	private function mouseUp(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);
		var mouseButton:MouseButton = getMouseButtonFromButton(event.button);

		mouseButtonsHeld.remove(Type.enumIndex(mouseButton));
	}

	private function mouseMove(event:Dynamic):Void
	{
		this.mousePos = this.getMousePositionFromEvent(event);
	}

	private function mouseWheel(event:Dynamic):Void
	{
		var ticks:Int = 0;

		var firefoxReg:EReg = new EReg("Firefox", "i");
		if (firefoxReg.match(js.Browser.window.navigator.userAgent))
			ticks = event.detail;
		else
			ticks = Math.round(event.wheelDelta / 120);
	}

	private function keyDown(event:Dynamic):Void
	{
		var keyCode:Int = event.keyCode; 
		var key:Key = getKeyFromCode(keyCode);

		heldKeys.set(Type.enumIndex(key), key);
	}

	private function keyUp(event:Dynamic):Void
	{
		var keyCode:Int = event.keyCode; 
		var key:Key = getKeyFromCode(keyCode);

		heldKeys.remove(Type.enumIndex(key));
	}

	public function update(msTimeStep:Int):Void
	{
		// Get all recorded events into a temporary store so that new events don't affect the loop
		var tempEvents:Array<RecordedEvent> = new Array();
		for (recordedEvent in this.recordedEvents)
		{
			tempEvents.push(recordedEvent);
		}
		this.recordedEvents = new Array();

		this.timeLeftToRecalculateOffsetMs -= msTimeStep;
		if (this.timeLeftToRecalculateOffsetMs <= 0)
		{
			this.timeLeftToRecalculateOffsetMs = DEFAULT_OFFSET_RECALC_DELAY_MS;
			this.recalculateCanvasOffset();
		}
	}


	/*
		Usual Framework type Functions
		------------------------------------------------
	*/
	/* *
	public function preUpdate(msTimeStep:Int):Void
	{
		this.queueRegisters = true;
	}

	public function postUpdate(msTimeStep:Int):Void
	{
		this.queueRegisters = false;
		this.flushQueues();
	}

	public function destroy():Void
	{
		for (mouseButton in mouseButtonsHeld.keys())
			mouseButtonsHeld.remove(mouseButton);
		mouseButtonsHeld = null;

		this.mousePos = null;

		for (key in heldKeys.keys())
			heldKeys.remove(key);
		heldKeys = null;

		this.targetElement.onmousedown = null;
		this.targetElement.onmouseup = null;
		this.targetElement.onmousemove = null;

		this.targetElement.oncontextmenu = null;
		js.Browser.document.onmousewheel = null;
		js.Browser.document.onkeydown = null;
		js.Browser.document.onkeyup = null;
		var firefoxReg:EReg = new EReg("Firefox", "i");
		if (firefoxReg.match(js.Browser.window.navigator.userAgent))
			js.Browser.document.removeEventListener("DOMMouseScroll", this.mouseWheel, true);
		else
			js.Browser.document.onmousewheel = null;
		this.targetElement = null;
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
	/* */


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

	/*
		Key and Button Mapping functions	
		------------------------------------------
	*/
	public function setDocumentOffset(value:Vector2):Void
	{
		this.targetDocumentOffset = value;
	}

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
				mousePos = new Vector2( event.clientX + js.Browser.document.body.scrollLeft + js.Browser.document.documentElement.scrollLeft,
										event.clientY + js.Browser.document.body.scrollTop + js.Browser.document.documentElement.scrollTop);
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

	public function recalculateCanvasOffset():Void
	{
		var offset:Vector2 = new Vector2(0, 0);

		if (this.targetElement != null && this.targetElement.offsetParent != null)
		{
			var ele:Element = this.targetElement;
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
}

// TODO: Keep old code here until I know if I need it or not
/* *
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
/* */
