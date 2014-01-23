package titanium_reindeer.core;

import js.html.Element;

import titanium_reindeer.Enums;
import titanium_reindeer.spatial.Vector2;

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
	/**
	 * Determines how often we check the window position of our target element
	 * Used to accurately find the mouse position in the browser window
	 * 
	 * value = 1000
	 */
	public static inline var DEFAULT_OFFSET_RECALC_DELAY_MS:Int = 1000;


	/**
	 * The DOM element where input handlers are attached.
	 */
	private var targetElement:Element;

	/**
	 * Milliseconds left before the DOM element offset should be recalculated.
	 * This is used to make sure an expensive operation is not performed too often.
	 */
	private var timeLeftToRecalculateOffsetMs:Int;

	/**
	 * A mapping of mouse buttons held down at any given moment.
	 */
	private var mouseButtonsHeld:Map<MouseButton, Bool>;

	/**
	 * A mapping of keyboard buttons held down at any given moment.
	 */
	private var keysHeld:Map<Key, Bool>;

	/**
	 * A temporary history of mouse buttons pressed since the state was refreshed.
	 */
	private var mouseButtonsPressed:Map<MouseButton, Bool>;

	/**
	 * A temporary history of mouse buttons pressed since the state was refreshed.
	 */
	private var keysPressed:Map<Key, Bool>;
	
	/**
	 * The current offset of the game DOM element used to capture events. This offset is subtracted
	 * from the mouse position captured to accurately calculate the mouse position in the game.
	 */
	private var targetDocumentOffset:Vector2;

	/**
	 * The relative position of the mouse over the game's DOM element.
	 */
	public var mousePos(default, null):Vector2;

	public function new(targetElement:Element)
	{
		this.targetElement = targetElement;
		this.timeLeftToRecalculateOffsetMs = DEFAULT_OFFSET_RECALC_DELAY_MS;

		this.mouseButtonsHeld = new Map();
		this.mouseButtonsPressed = new Map();
		this.keysHeld = new Map();
		this.keysPressed = new Map();

		this.mousePos = new Vector2(0, 0);

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

		this.targetDocumentOffset = new Vector2(0, 0);
	}

	/**
	 * Callback function for right click or context menu action.
	 * Returning false disabled the context menu from appearing.
	 */
	private function contextMenu(event:Dynamic):Bool
	{
		// TODO: Set a state to check 
		return false;
	}

	// Input Event Handlers
	// -----------------------------------------------------------------------------------------------

	/**
	 * Calls the right method for the particular input event.
	 * Used to queue up events to be called in the update method.
	 * Kept around for when I might choose to keep a frame-by-frame history of input events.
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
	}

	/**
	 * Called whenever a mouse button is pressed.
	 */
	private function mouseDown(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);
		var mouseButton:MouseButton = getMouseButtonFromButton(event.button);

		mouseButtonsHeld.set(mouseButton, true);
	}

	/**
	 * Called whenever a mouse button is released.
	 */
	private function mouseUp(event:Dynamic):Void
	{
		var mousePos:Vector2 = this.getMousePositionFromEvent(event);
		var mouseButton:MouseButton = getMouseButtonFromButton(event.button);

		if ( mouseButtonsHeld.exists(mouseButton) )
			mouseButtonsPressed.set(mouseButton, true);
		mouseButtonsHeld.remove(mouseButton);
	}

	/**
	 * Called whenever the button moves.
	 * Keeps public property mousePos up-to-date
	 */
	private function mouseMove(event:Dynamic):Void
	{
		this.mousePos = this.getMousePositionFromEvent(event);
	}

	// TODO: Need a way to use this function...
	/**
	 * Called whenever the mouse wheel is used.
	 * After recent refactored it doesn't do anything though...
	 */
	private function mouseWheel(event:Dynamic):Void
	{
		var ticks:Int = 0;

		var firefoxReg:EReg = new EReg("Firefox", "i");
		if (firefoxReg.match(js.Browser.window.navigator.userAgent))
			ticks = event.detail;
		else
			ticks = Math.round(event.wheelDelta / 120);
	}

	/**
	 * Called whenever a key is pressed.
	 */
	private function keyDown(event:Dynamic):Void
	{
		var keyCode:Int = event.keyCode; 
		var key:Key = getKeyFromCode(keyCode);

		keysHeld.set(key, true);
	}

	/**
	 * Called whenever a key is released.
	 */
	private function keyUp(event:Dynamic):Void
	{
		var keyCode:Int = event.keyCode; 
		var key:Key = getKeyFromCode(keyCode);

		if ( keysHeld.exists(key) )
			keysPressed.set(key, true);
		keysHeld.remove(key);
	}

	/**
	 * Call to update the offset of target element.
	 * Will hopefully get removed in later refactors.
	 */
	public function update(msTimeStep:Int):Void
	{
		this.timeLeftToRecalculateOffsetMs -= msTimeStep;
		if (this.timeLeftToRecalculateOffsetMs <= 0)
		{
			this.timeLeftToRecalculateOffsetMs = DEFAULT_OFFSET_RECALC_DELAY_MS;
			this.recalculateCanvasOffset();
		}

		this.mouseButtonsPressed = new Map();
		this.keysPressed = new Map();
	}

	/**
	 * Returns the state of a mouse button. If true it's currently depressed.
	 */
	public function isMouseButtonDown(mouseButton:MouseButton):Bool
	{
		return this.mouseButtonsHeld.exists(mouseButton);
	}

	/**
	 * Returns the state of a key. If true it's currently depressed.
	 */
	public function isKeyDown(key:Key):Bool
	{
		return this.keysHeld.exists(key);
	}

	/**
	 * Returns true if the mouse button was pressed since the last refresh.
	 */
	public function wasMouseButtonPressed(mouseButton:MouseButton):Bool
	{
		return this.mouseButtonsPressed.exists(mouseButton);
	}

	/**
	 * Returns true if the key was pressed since the last refresh.
	 */
	public function wasKeyPressed(key:Key):Bool
	{
		return this.keysPressed.exists(key);
	}

	/**
	 * Allows the target elements document offset to be set manually.
	 */
	public function setDocumentOffset(value:Vector2):Void
	{
		this.targetDocumentOffset = value;
	}

	/**
	 * A conveinent wrapper function for getting the mouse position with all the right calculations
	 * and offsets applied to get the right position of the mouse relative to the top left of the
	 * target element.
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
				mousePos = new Vector2( event.clientX + js.Browser.document.body.scrollLeft + js.Browser.document.documentElement.scrollLeft,
										event.clientY + js.Browser.document.body.scrollTop + js.Browser.document.documentElement.scrollTop);
			}

		else
			return new Vector2(0, 0);

		return mousePos.subtract(this.targetDocumentOffset);
	}

	/**
	 * Converts the int returns by event.button to a value of the MouseButton enum.
	 */
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

	/**
	 * Converts the int returns by event.keyCode to a value of the Key enum.
	 */
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

	/**
	 * Iterates over all the ancestors of the target element to find it's absolute position on the
	 * web page.
	 * Used to ensure an accurate mouse position relative to the target element.
	 */
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
