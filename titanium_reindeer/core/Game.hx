package titanium_reindeer.core;

import haxe.Timer;
import js.html.Element;

import titanium_reindeer.rendering.Canvas2D;
import titanium_reindeer.rendering.Color;

class Game
{
	public static inline var DEFAULT_UPDATES_TIME_MS:Int 	= 17; // 60 fps


	public var targetElement(default, null):Element;
	public var width:Int;
	public var height:Int;

	public var debugMode:Bool;
	public var maxAllowedUpdateLengthMs(default, set):Int;
	private function set_maxAllowedUpdateLengthMs(value:Int):Int
	{
		if (value != this.maxAllowedUpdateLengthMs)
		{
			this.maxAllowedUpdateLengthMs = Std.int(Math.max(1, Math.min(value, Math.POSITIVE_INFINITY)));
		}

		return this.maxAllowedUpdateLengthMs;
	}

	private var msLastTimeStep:Int;

	private var exitGame:Bool;

	public var pageCanvas(default, null):Canvas2D;
	public var input(default, null):InputState;

	public function new(targetHtmlId:String, ?width:Int, ?height:Int, ?debugMode:Bool)
	{
		this.targetElement = js.Browser.document.getElementById(targetHtmlId);
		this.targetElement.style.position = "relative";
		this.pageCanvas = new Canvas2D("main", width, height);
		this.pageCanvas.appendToDom(this.targetElement);

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

	public function play():Void
	{
		// Start the game loop
		requestAnimFrame();
	}

	public function recalculateViewPort():Void
	{
		var size = this.targetElement.getBoundingClientRect();
		this.resize(Math.round(size.width), Math.round(size.height));
	}

	public function resize(width:Int, height:Int):Void
	{
		this.width = width;
		this.height = height;
		this.pageCanvas.resize(this.width, this.height);
	}

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
			for (r in 0...requestFuncs.length)
			{
				var req = requestFuncs[r];
				if (this.targetElement[req])
				{
					isRequestMade = true;
					this.targetElement.addEventListener(changeFuncs[r], function (event) {
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

	private function viewPortChanged():Void
	{
	}

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

			// Game Logic
			this.preUpdate(msTimeStep);

			this.update(msTimeStep);
	
			this.postUpdate(msTimeStep);

			// Request a game loop tick from the browser
			requestAnimFrame();
		}

		return true;
	}

	// Setup the request animation frame wrapper for browser compatibility
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
				js.Browser.window.setTimeout(function () {
						this.gameLoop(Game.DEFAULT_UPDATES_TIME_MS);
						}, Game.DEFAULT_UPDATES_TIME_MS);
		}
	}

	private function preUpdate(msTimeStep:Int):Void
	{
	}

	private function update(msTimeStep:Int):Void
	{
	}

	private function postUpdate(msTimeStep:Int):Void
	{
	}

	public function destroy():Void
	{
		this.targetElement = null;
	}

	public function stopGame():Void
	{
		this.exitGame = true;
	}
}
