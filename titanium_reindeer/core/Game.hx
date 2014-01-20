package titanium_reindeer.core;

import haxe.Timer;
import js.html.Element;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.Color;

/**
 * The Game class represents an instance of an entire game. It's effectively the root scene of the game.
 * It is responsible for knowing the dom element on the web page where the game is to be rendered and
 * input handlers are attached.
 *
 * This class provides convenient methods for changing the games viewport and for maintaining a game loop
 * using the requestAnimationFrame() function.
 */
class Game
{
	/** 
	 * The default frame length if we have to fall back to setTimeout for the gameloop
	 */
	public static inline var DEFAULT_UPDATES_TIME_MS:Int 	= 17; // 60 fps


	public var debugMode:Bool;

	/** 
	 * The defined maximum frame length in the case where a frame takes too long and the next is lengthened
	 */
	public var maxAllowedUpdateLengthMs(default, set):Int;
	private function set_maxAllowedUpdateLengthMs(value:Int):Int
	{
		if (value != this.maxAllowedUpdateLengthMs)
		{
			this.maxAllowedUpdateLengthMs = Std.int(Math.max(1, Math.min(value, Math.POSITIVE_INFINITY)));
		}

		return this.maxAllowedUpdateLengthMs;
	}

	/**
	 * The dom element where rendering is done and input handlers are made
	 */
	public var targetElement(default, null):Element;

	/**
	 * The root canvas for rendering, it is appended inside our target dom element
	 */
	public var pageCanvas(default, null):Canvas2D;

	/**
	 * The root input manager an instance of this is passed around for controllers to query input state
	 */
	public var input(default, null):InputState;

	/**
	 * The width of the viewport assumed the maximum for the game
	 */
	public var width:Int;

	/**
	 * The height of the viewport assumed the maximum for the game
	 */
	public var height:Int;

	/**
	 * The lenght of the last frame
	 */
	private var msLastTimeStep:Int;

	/**
	 * A flag which when set causes the game loop to terminate and the game to be destroyed
	 */
	private var exitGame:Bool;

	public function new(targetHtmlId:String, ?width:Int, ?height:Int, ?debugMode:Bool)
	{
		// Append the main canvas to the our target element
		this.targetElement = js.Browser.document.getElementById(targetHtmlId);
		this.pageCanvas = new Canvas2D("main", width, height);
		this.pageCanvas.appendToDom(this.targetElement);

		// Bind input events to the target element 
		this.input = new InputState(targetElement);

		this.width = width == null ? 400 : width;
		this.height = height == null ? 300 : height;

		this.exitGame = false;

		this.debugMode = debugMode == null ? false : debugMode;
		this.maxAllowedUpdateLengthMs = 1000; // 1 fps

		if (debugMode)
		{
			/* *
			// TODO: Wtf happened to setErrorHandler
			js.Browser.setErrorHandler(function (msg:String, stack:Array<String>)
			{
				js.Browser.alert("ERROR[ "+msg+" ]");
				trace(stack);
				return true;
			});
			/* */
		}
	}

	/**
	 * Start the game
	 */
	public function play():Void
	{
		// Start the game loop
		requestAnimFrame();
	}

	/**
	 * Propagate resize based on the pixel size of the target element
	 */
	public function recalculateViewPort():Void
	{
		var size = this.targetElement.getBoundingClientRect();
		this.resize(Math.round(size.width), Math.round(size.height));
	}

	/**
	 * Causes the game to resize it's rendering region
	 */
	public function resize(width:Int, height:Int):Void
	{
		this.width = width;
		this.height = height;
		this.pageCanvas.resize(this.width, this.height);
	}

	/**
	 * Ask the browser (on behalf of the user) to put the game into fullscreen
	 */
	public function requestFullScreen():Void
	{
		var isRequestMade:Bool = false;

		// Make fullscreen
		untyped
		{
			var requestFuncs:Array<String> = [
				"requestFullscreen",
				"webkitRequestFullscreen",
				"webkitRequestFullScreen",
				"mozRequestFullScreen",
				"msRequestFullscreen"
			];
			var changeFuncs:Array<String> = [
				"fullscreenchange",
				"webkitfullscreenchange",
				"webkitfullscreenchange",
				"mozfullScreenchange",
				"MSFullscreenchange"
			];
			var errorFuncs:Array<String> = [
				"fullscreenerror",
				"webkitfullscreenerror",
				"webkitfullscreenerror",
				"mozfullScreenerror",
				"MSFullscreenerror"
			];
			// Try each different request fullscreen function
			for (r in 0...requestFuncs.length)
			{
				var req = requestFuncs[r];
				if (this.targetElement[req])
				{
					isRequestMade = true;
					this.targetElement.addEventListener(changeFuncs[r], function (event) {
						// Find the new size of the game and propagate it
						this.recalculateViewPort();
					});
					this.targetElement.addEventListener(errorFuncs[r], function (event) {
						js.Browser.window.alert("Either the target element can not be made fullscreen or you didn't request from a user interaction");
					});
					this.targetElement[req]();
					break;
				}
			}
		}
	}

	/**
	 * The main game loop function. Each call to this is a logical step in time in the game.
	 */
	private function gameLoop(now:Float):Bool
	{
		if (exitGame)
		{
			this.destroy();
		}
		else
		{
			if (this.msLastTimeStep == null)
				this.msLastTimeStep = 0;

			var msTimeStep:Int;
			if (now == null)
				msTimeStep = Game.DEFAULT_UPDATES_TIME_MS;
			else
				msTimeStep = Std.int(Math.min(now - this.msLastTimeStep, this.maxAllowedUpdateLengthMs));
			this.msLastTimeStep = Math.round(now);

			// Where all the magic happens
			this.preUpdate(msTimeStep);
			this.update(msTimeStep);
			this.postUpdate(msTimeStep);

			// Request a game loop tick from the browser
			requestAnimFrame();
		}

		return true;
	}

	/**
	 * Setup the request animation frame wrapper for browser compatibility
	 */
	private function requestAnimFrame()
	{
		untyped
		{
			if (js.Browser.window.requestAnimationFrame)
				js.Browser.window.requestAnimationFrame(gameLoop);

			else if (js.Browser.window.webkitRequestAnimationFrame)
				js.Browser.window.webkitRequestAnimationFrame(gameLoop);

			else if (js.Browser.window.mozRequestAnimationFrame)
				js.Browser.window.mozRequestAnimationFrame(gameLoop);

			else if (js.Browser.window.oRequestAnimationFrame)
				js.Browser.window.oRequestAnimationFrame(gameLoop);

			else if (js.Browser.window.msRequestAnimationFrame)
				js.Browser.window.msRequestAnimationFrame(gameLoop);

			else
				// setTimeout fall back
				js.Browser.window.setTimeout(function () {
					this.gameLoop(Game.DEFAULT_UPDATES_TIME_MS);
				}, Game.DEFAULT_UPDATES_TIME_MS);
		}
	}

	/**
	 * Designed to be overridden in a subclass
	 */
	private function preUpdate(msTimeStep:Int):Void {}

	/**
	 * Designed to be overridden in a subclass
	 */
	private function update(msTimeStep:Int):Void {}

	/**
	 * Designed to be overridden in a subclass
	 */
	private function postUpdate(msTimeStep:Int):Void {}

	/**
	 * Should be called just before the game instance is removed
	 */
	public function destroy():Void
	{
		this.targetElement = null;
	}

	/**
	 * Tells the game to stop looping in the next step
	 */
	public function stopGame():Void
	{
		this.exitGame = true;
	}
}
